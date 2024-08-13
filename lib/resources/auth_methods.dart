import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendsphere/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //signing up user
  Future<String> SignUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error Occurred";
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty) {
        res = "Please enter all the fields";
      } else {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'username': username,
          'email': email,
          'uid': cred.user!.uid,
          'bio': bio,
          'following': [],
          'followers': [],
          'photoUrl': photoUrl,
        });
        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
