import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Models/OneUser.dart';
import 'package:mauripress/Services/DateOperations.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class PhoneMaster extends OneUser with ChangeNotifier {
  bool isVerified;
  bool logged = false;
  // var humanDate;
  List myHistory = [];
  int ordersNb = 0;
  int deliveredNb = 0;
  int pendingNb = 0;

  FirebaseUser dauser;
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  PhoneMaster() {
    dauser = null;
  }

  Future setUser(FirebaseUser user) async {
    dauser = user;
    this.logged = true;
    isDisabled = false;
    try {
      await talk.ref.document(dauser.uid).get().then((dadoc) {
        isDisabled = dadoc.data['isDisabled'];
        if (!isDisabled)
          updateFromMap(docId: dadoc.documentID, data: dadoc.data);
      });
      await fetchProfilePic();

      return !isDisabled;
    } catch (e) {
      print(e.message);
    }
  }

  Future logWmail(
      {@required String email,
      @required String pass,
      bool checkingPass = false}) async {
    bool errthere = false;
    try {
      AuthResult authResult = await _fbAuth.signInWithEmailAndPassword(
          email: email, password: pass);
      if (!checkingPass && authResult.user != null) {
        // var timeCreated =
        //     Timestamp.fromDate(authResult.user.metadata.creationTime)
        //         .millisecondsSinceEpoch;
        // var timeNow = Timestamp.now().millisecondsSinceEpoch;
        // var time3daysago = 3 * 24 * 60 * 60 * 1000;

        // if (!authResult.user.isEmailVerified &&
        //     ((timeNow - timeCreated) > time3daysago)) {
        //   await authResult.user.sendEmailVerification();
        //   return "Ce compte n'a pas été confirmé, un message de confirmation a été envoyé à cet email";
        // }
        await setUser(authResult.user).then((val) {
          if ((val is bool) && val == false) errthere = true;
        });
        FirebaseMessaging damess = FirebaseMessaging();
        var daToken = await damess.getToken();
        await talk.updateDocument(id, {'deviceToken': daToken});
        if (errthere) return "Ce compte a été désactivé !";
        this.logged = true;
        if (dauser.displayName == null)
          await updateUserAuthInfo(fname: firstName);

        notifyListeners();
      }
      return authResult.user != null;
    } catch (e) {
      print(e.code);
      if (checkingPass) return false;
      switch (e.code) {
        case "ERROR_NETWORK_REQUEST_FAILED":
          return "Vérifier votre connexion internet !";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          return "Trop de tentatives, réessayer plus tard ! !";
          break;
        case "ERROR_INVALID_EMAIL":
          return "Veuillez saisir un email valide !";
          break;
        case "ERROR_USER_DISABLED":
          return "Votre compte est désactivé !";
          break;
        default:
          return "Email ou mot de passe incorrecte !";
      }
    }
  }

  updateUserAuthInfo({String fname}) async {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = fname ?? "Anonyme";
    await dauser.updateProfile(updateInfo);
  }

  Future signupWmail({
    @required String email,
    @required String pass,
    @required String firstName,
    @required String lastName,
  }) async {
    try {
      email = email.trim();
      pass = pass.trim();
      firstName = firstName.trim();
      lastName = lastName.trim();

      var authResult = await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        this.dauser = authResult.user;
        talk.addDocumentById(dauser.uid, {
          'email': dauser.email,
          'firstName': firstName,
          'lastName': lastName,
          'isDisabled': false,
          'rightLevel': 1,
          'fullName': firstName + ' ' + lastName,
          'creationDate': authResult.user.metadata.creationTime
        });
        this.firstName = firstName;
        this.lastName = lastName;
      }
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = firstName;
      authResult.user.updateProfile(updateInfo);

      dauser.sendEmailVerification();

      notifyListeners();
      return authResult.user != null;
    } catch (e) {
      print(e.message);
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          return "Le mot de passe est faible !";
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
          return "Vérifier votre connexion internet !";
          break;
        case "ERROR_INVALID_EMAIL":
          return "Veuillez saisir un email valide !";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return "Cet email est déja utilisé !";
          break;
        default:
          return "Vérifier votre connexion internet !";
      }
    }
  }

  Future setNewPass(String oldPass, String newPass) async {
    bool verdict;
    bool secondVerdict;
    String errmsg = "meaw";
    await logWmail(email: dauser.email, pass: oldPass, checkingPass: true)
        .then((val) {
      verdict = val;
    });
    if (verdict) {
      await dauser.updatePassword(newPass).then((val) {
        secondVerdict = true;
      }).catchError((e) {
        secondVerdict = false;
        switch (e.code) {
          case "ERROR_WEAK_PASSWORD":
            errmsg = "Le mot de passe est faible !";
            break;
          case "ERROR_NETWORK_REQUEST_FAILED":
            return "Vérifier votre connexion internet !";
            break;
          default:
            errmsg = "Veuillez vérifier votre connexion internet !";
        }
      });
      if (secondVerdict)
        return true;
      else
        return errmsg;
    } else
      return "Ancien mot de passe incorrecte !";
  }

  Future addMoreInfo(
      {@required String address,
      @required int phoneNumber,
      @required List<double> myPos,
      File daFile}) async {
    bool addressThere = true, numberThere = true, imageThere = true;
    Map<String, dynamic> daData = {};

    if (address == null || address.trim().length == 0) {
      addressThere = false;
    } else
      daData.addAll({'address': address});
    if (addressThere && address.trim().length < 4) {
      print("adderr");
      return "Veuillez saisir une adresse correcte !";
    }

    if (phoneNumber == null || phoneNumber.toString().trim().length == 0) {
      numberThere = false;
    } else
      daData.addAll({'phoneNumber': phoneNumber});

    if (numberThere && phoneNumber.toString().trim().length != 8) {
      print(phoneNumber);
      print("numerr");
      return "Saisir un numéro mauritanien correcte !";
    }

    if (daFile == null) {
      imageThere = false;
      print('image not here');
    } else {
      print("imagehere");
      StorageReference ref =
          FirebaseStorage.instance.ref().child(id + "/profile/image.jpg");
      StorageUploadTask uploadTask = ref.putFile(daFile);
      await uploadTask.onComplete;
      fetchProfilePic().whenComplete(() {
        DefaultCacheManager().emptyCache();
        notifyListeners();
      });
    }
    if (myPos.length != 0 || myPos[0] != 0)
      daData.addAll({
        'gpsPos': {'latitude': myPos[0], 'longitude': myPos[1]}
      });
    if (addressThere || numberThere)
      return await talk
          .updateDocument(dauser.uid, daData
              // {
              //   'address': address,
              //   'phoneNumber': phoneNumber,
              //   'gpsPos': {'latitude': myPos[0], 'longitude': myPos[1]}
              // }
              )
          .whenComplete(() {
        setUser(this.dauser);
      });
    notifyListeners();
  }

  Future getHistory() async {
    DbTalker talk2lines = locator.get<Talk2Lines>();
    DbTalker talk2orders = locator.get<Talk2Orders>();
    var unicity;
    var lastIndex = 0;
    DateTime disDate;
    String disId;
    int token;
    List dateList = [];
    List<String> idList = [];

    var aMonthAgo = Timestamp.fromMillisecondsSinceEpoch(
        (Timestamp.now().millisecondsSinceEpoch - (30 * 24 * 60 * 60 * 1000)));
    await talk2lines.ref
        .where('userid', isEqualTo: this.dauser.uid)
        .where('dadate', isGreaterThan: aMonthAgo)
        .orderBy('dadate', descending: true)
        .getDocuments()
        .then((dadoc) {
      dadoc.documents.forEach((adoc) {
        disDate = (adoc.data['dadate'] as Timestamp).toDate();
        disId = adoc.documentID;
        idList.add(disId);
        token = disDate.day + disDate.month + disDate.year;

        if (unicity == null || unicity != token) {
          dateList.add([disDate, []]);
          if (unicity != null) lastIndex++;
          unicity = token;
        }
        dateList[lastIndex][1]
            .add([[], "${disDate.hour}h:${disDate.minute}", false, disId]);
      });
    });

    var catalogue = locator.get<ClotheCatalogue>();
    if (idList.length != 0)
      await talk2orders.ref
          .where('lineid', whereIn: idList)
          .getDocuments()
          .then((snap) {
        dateList.forEach((elem) {
          elem[1].forEach((elem) {
            elem[0] = snap.documents
                .where((dadoc) => dadoc.data['lineid'] == elem[3])
                .map((elem) {
              var elemInfo = catalogue.clotheForId(elem['clotheid']);
              return [elem['qty'], elemInfo[0], (elemInfo[1] * elem['qty'])];
            }).toList();
          });
        });
      });

    myHistory = dateList;
    print("waa");
  }

  Future removeMe() async {
    await talk.removeDocument(id);
  }

  Future getOrdersNbThisWeek() async {
    DbTalker talk2lines = locator.get<Talk2Lines>();
    await talk2lines.ref
        .where('dadate', isGreaterThanOrEqualTo: getLastWeekDay(1))
        .where('userid', isEqualTo: id)
        .getDocuments()
        .then((dasnap) {
      ordersNb = 0;
      deliveredNb = 0;
      pendingNb = 0;
      dasnap.documents.forEach((elem) {
        if (!elem.data['isCanceled']) {
          ordersNb++;
          if (elem.data['isDelivered'])
            deliveredNb++;
          else
            pendingNb++;
        }
        // if(elem.data['is'])
      });
    });
    // print(ordersNb);
    // print(deliveredNb);
  }
}
