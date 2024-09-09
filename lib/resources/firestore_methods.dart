import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendsphere/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendsphere/resources/storage_methods.dart';
import 'package:friendsphere/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> createPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'Some error occurred';
    try {
      String? photoUrl = await StorageMethods().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      final baseUrl = getBaseUrl();
      final url = Uri.parse('$baseUrl/api/v1/posts/create');
      final cookieHeader = await retrieveData('jwt');
      print(cookieHeader);
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Cookie": cookieHeader!
          },
          body: jsonEncode({'text': description, 'img': profImage}));

      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
      } else {
        throw Exception(response.body);
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> followUnfollowUser(String followId) async {
    String res = "Some error occurred";
    try {
      User loggedUser = _auth.currentUser!;
      String userId = loggedUser.uid.toString();
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(userId).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([followId])
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([userId])
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([followId])
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([userId])
        });
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
