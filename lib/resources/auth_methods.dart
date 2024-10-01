import 'dart:typed_data';
// import 'package:cookie_jar/src/jar/persist.dart';
// import 'package:friendsphere/utils/utils.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendsphere/resources/storage_methods.dart';
import 'package:friendsphere/models/user.dart' as model;
import 'package:local_auth/local_auth.dart';
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication auth = LocalAuthentication();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  //signing up user
  Future<String> SignUpUser(
      {required String email,
      required String password,
      required String name,
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
            name: name,
            email: email,
            uid: cred.user!.uid,
            bio: bio,
            following: [],
            followers: [],
            photoUrl: photoUrl);
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

        bool authenticated = await _authenticateUser();

        if (authenticated) {
          res = "success";
        } else {
          res = "Authentication failed";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<bool> _authenticateUser() async {
    bool authenticated = false;
    try {

      // Check if the device can check biometrics and if it supports secure authentication (lock screen)
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      // bool isDeviceSupported = await auth.isDeviceSupported();

      // Check if there is any secure lock screen (password, PIN, or pattern) enabled
      bool hasLockScreen = await auth.isDeviceSupported();
      print(canCheckBiometrics);
      print(hasLockScreen);
      // Proceed if either biometrics or a secure lock screen is available
      if (canCheckBiometrics || hasLockScreen) {
        // Try to authenticate (biometric or fallback to lock screen password)
        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false, // Allows fallback to lock screen password if biometrics fail
          ),
        );
      } else {
        // No secure lock screen set up, skip authentication
        print('No lock screen security is set. Skipping authentication.');
        return true;
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
    return authenticated;
  }

  Future<void> singOut() async {
    await _auth.signOut();
  }
}

