import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final FirebaseAuth _fbAuth = FirebaseAuth.instance;

Future logWmail({@required String email, @required String pass}) async {
  try {
    AuthResult authResult =
        await _fbAuth.signInWithEmailAndPassword(email: email, password: pass);
        return authResult.user != null;
  } catch (e) {
    print(e.message);
  }
}

Future signupWmail({@required String email, @required String pass}) async {
  try {
    var authResult = await _fbAuth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return authResult.user != null;
  } catch (e) {
    print(e.message);
  }
}
