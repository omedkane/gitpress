import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:mauripress/Models/OneUser.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class OneLine {
  String id;
  String userid;
  String phoneNumber;
  String fullName;
  String address;
  String assignedTo;
  int totalPrice;
  Timestamp dadate;
  String frenchDate;
  bool isDelivered;
  bool isConfirmed;
  bool isCanceled;
  String assignedNawa;
  DbTalker talk = locator.get<Talk2Lines>();
  // Refine this shit afterwards ;

  Future cancelMe({bool how}) async {
    await talk.updateDocument(id, {'isCanceled': how ?? !this.isCanceled});
    await refreshLine();
  }

  Future deliverMe({bool how}) async {
    await talk.updateDocument(id, {
      'isDelivered': how ?? !this.isDelivered,
      'deliveryDate':
          (how ?? this.isDelivered) ? null : FieldValue.serverTimestamp()
    });
    await refreshLine();
  }

  Future confirmMe({bool how}) async {
    await talk.updateDocument(id, {'isConfirmed': how ?? !this.isConfirmed});
    await refreshLine();
  }

  Future assignMeTo(OneUser daUser) async {
    DbTalker uTalk = locator.get<Talk2Users>();
    String daToken;
    uTalk.getDocumentById(daUser.id).then((value) async {
      daToken = value.data['deviceToken'];
      if (daToken != null) {
        var shit = await post(
            "https://us-central1-mauripress-d1bc8.cloudfunctions.net/getMeData",
            body: {'daToken': daToken});
        print(shit.body);
      }else print("No Token");
    });
    await talk.updateDocument(
        id, {'assignedTo': daUser.id, 'assignedNawa': daUser.fullName});
    await refreshLine();
  }

  Future refreshLine() async {
    await talk.getDocumentById(id).then((dadoc) {
      setLineFromMap(dadoc.data);
    });
  }

  OneLine({
    this.id,
    this.userid,
    this.dadate,
    this.phoneNumber,
    this.fullName,
    this.address,
    this.totalPrice,
    this.frenchDate,
    this.isDelivered,
    this.isConfirmed,
    this.isCanceled,
    this.assignedNawa,
    this.assignedTo,
  });
  OneLine.fromMap(String daId, Map data, this.frenchDate) {
    id = daId ?? '';
    setLineFromMap(data);
  }

  setLineFromMap(Map data) {
    userid = data['userid'] ?? '';
    dadate = data['dadate'] ?? '';
    assignedTo = data['assignedTo'];
    assignedNawa = data['assignedNawa'];
    phoneNumber = data['phoneNumber'] ?? '';
    fullName = data['fullName'] ?? '';
    address = data['address'] ?? '';
    totalPrice = data['totalPrice'] ?? 0;
    isDelivered = data['isDelivered'] ?? false;
    isConfirmed = data['isConfirmed'] ?? false;
    isCanceled = data['isCanceled'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'userid': userid,
        'dadate': FieldValue.serverTimestamp(),
        'assignedTo': null,
        'assignedNawa': null,
        'phoneNumber': phoneNumber,
        'fullName': fullName,
        'address': address,
        'totalPrice': totalPrice,
        'isDelivered': false,
        'isConfirmed': false,
        'isCanceled': false
      };
}
