import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/locator.dart';

class DbTalker implements Talk2Users, Talk2Clothes, Talk2Lines, Talk2Orders {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
  DbTalker(this.path) {
    this.ref = _db.collection(path);
  }
  Future updateAll(updata) async {
    var batch = ref.firestore.batch();
    await ref.getDocuments().then((snap) {
      snap.documents.forEach((dadoc) {
        batch.updateData(ref.document(dadoc.documentID), updata);
        // updateDocument(dadoc.documentID, updata);
      });
    });
    await batch.commit();
  }

  Future updateWhere(Query qSnap, updata) async {
    var batch = ref.firestore.batch();
    await qSnap.getDocuments().then((snap) {
      snap.documents.forEach((dadoc) {
        batch.updateData(ref.document(dadoc.documentID), updata);
        // updateDocument(dadoc.documentID, updata);
      });
    });
    await batch.commit();
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return ref.add(data);
  }

  Future addDocumentById(String id, Map<String, dynamic> data) {
    return ref.document(id).setData(data);
  }

  Future updateDocument(String id, Map<String, dynamic> data) {
    return ref.document(id).updateData(data);
  }

  static Future verifyUser(String daemail, String dapass) async {
    FirebaseAuth _fbAuth = FirebaseAuth.instance;
    try {
      AuthResult daAuth = await _fbAuth.signInWithEmailAndPassword(
          email: daemail.trim(), password: dapass.trim());
      var daUser = locator.get<PhoneMaster>();
      daUser.setUser(daAuth.user);

      if (daAuth.user.isEmailVerified && daAuth != null)
        return true;
      else {
        daAuth.user.sendEmailVerification();
        return "Activez votre compte !";
      }
    } catch (e) {
      return "Mot de passe incorrect !";
    }
  }
}

abstract class Talk2Users {}

abstract class Talk2Clothes {}

abstract class Talk2Orders {}

abstract class Talk2Lines {}

Future checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
