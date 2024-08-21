import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendsphere/resources/storage_methods.dart';
import 'package:friendsphere/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await
        _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }
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
        model.User user = model.User(
            username: username,
            email: email,
            uid: cred.user!.uid,
            bio: bio,
            following: [],
            followers: [],
            photoUrl: photoUrl
        );
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
  //logging in user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error Occuresd";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> singOut() async {
    await _auth.signOut();
  }
}
