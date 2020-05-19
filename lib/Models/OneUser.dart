import 'package:firebase_storage/firebase_storage.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class OneLocation {
  final double latitude;
  final double longitude;

  OneLocation({this.latitude, this.longitude});
}

class OneUser {
  String id;
  String firstName;
  String lastName;
  String fullName;
  String address;
  String email;
  String phoneNumber;
  bool isDisabled;
  int rightLevel;
  String privilege = '';
  OneLocation gpsPos;
  DbTalker talk = locator.get<Talk2Users>();
  String imageURL =
      "https://firebasestorage.googleapis.com/v0/b/mauripress-d1bc8.appspot.com" +
          "/o/userprof3.png?alt=media&token=ca4a72f7-0fd6-497b-ba0f-dcffd55303a7";

  OneUser({this.id});

  OneUser.fromMap(String docId, Map data) {
    updateFromMap(data: data, docId: docId);
    // fetchProfilePic();
  }
  Future fetchProfilePic() async {
    await FirebaseStorage.instance
        .ref()
        .child(id + "/profile/image.jpg")
        .getDownloadURL()
        .then((val) {
      imageURL = val.toString();
      // print(val.toString());
    }).catchError((err) {
      print("Jack is dead !");
      // imageURL =
      //     "https://firebasestorage.googleapis.com/v0/b/mauripress-d1bc8.appspot.com" +
      //         "/o/userprof3.png?alt=media&token=ca4a72f7-0fd6-497b-ba0f-dcffd55303a7";
    });
  }

  updateFromMap({String docId, Map data}) {
    if (docId != null) {
      id = docId ?? '';
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      fullName = data['fullName'] ?? '';
      email = data['email'] ?? '';
    }
    address = data['address'] ?? '';
    isDisabled = data['isDisabled'] ?? false;
    gpsPos = data['gpsPos']['latitude'] == 0
        ? null
        : OneLocation(
            latitude: data['gpsPos']['latitude'],
            longitude: data['gpsPos']['longitude']);
    rightLevel = data['rightLevel'] ?? 0;
    privilege = data['rightLevel'] == 83
        ? "Administrateur"
        : (data['rightLevel'] == 85
            ? "Gérant de livraison"
            : (data['rightLevel'] == 87 ? "Livreur" : 'Client'));
    phoneNumber = data['phoneNumber'].toString() ?? '';
    // fetchProfilePic();
  }

  Future setPrivilege(int rightLevel) async {
    DbTalker lineTalk = locator.get<Talk2Lines>();
    try {
      await talk.updateDocument(id, {'rightLevel': rightLevel});
      lineTalk.updateWhere(lineTalk.ref.where('assignedTo', isEqualTo: id),
          {'assignedTo': null, 'assignedNawa': null});
      await talk.getDocumentById(id).then((snap) {
        updateFromMap(data: snap.data);
      });
      return privilege;
    } catch (error) {
      return false;
    }
  }

  Future disableMe(bool how) async {
    try {
      await talk.updateDocument(id, {'isDisabled': how});
      isDisabled = how;
    } catch (e) {}
  }

  Future verifyUserStatus() async {
    await talk.getDocumentById(id).then((dadoc) {
      updateFromMap(data: dadoc.data);
    });
  }

  Map toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'rightLevel': rightLevel ?? 1,
      'isDisabled': isDisabled ?? false,
    };
  }
}
