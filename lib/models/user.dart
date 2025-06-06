import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String  email;
  final String name;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List ?followers;
  final List ?following;


  const User(
      {required this.username,
        required this.name,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      });
  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot["username"],
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
