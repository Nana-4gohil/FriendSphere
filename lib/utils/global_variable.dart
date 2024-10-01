import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendsphere/screens/add_post_screen.dart';
import 'package:friendsphere/screens/feed_screen.dart';
import 'package:friendsphere/screens/login_screen.dart';
import 'package:friendsphere/screens/feed_screen.dart';
import 'package:friendsphere/screens/profile_screen.dart';
import 'package:friendsphere/screens/search_screen.dart';

import '../widgets/post_card.dart';
const webSreenSize = 600;
List<Widget> HomeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
