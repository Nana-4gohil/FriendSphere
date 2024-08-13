import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendsphere/responsive/mobile_screen_layout.dart';
import 'package:friendsphere/responsive/responsive_layout.dart';
import 'package:friendsphere/responsive/web_screen_layout.dart';
import 'package:friendsphere/utils/colors.dart';
import 'package:friendsphere/screens/login_screen.dart';
import 'package:friendsphere/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBfzYYc7fNs7Qdy_kMZDBcFFuUnHke8hOg",
            appId: "1:5232096751:web:30122111465e149a1bb21a",
            messagingSenderId: "5232096751",
            projectId: "friendsphere-90f90",
            storageBucket: "friendsphere-90f90.appspot.com"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAe-U1sjFd_4b4g_xMW5YQq4Dt80E5fOCY",
            appId: "1:5232096751:android:a74fac75f1210a631bb21a",
            messagingSenderId: "5232096751",
            projectId: "friendsphere-90f90",
            storageBucket: "friendsphere-90f90.appspot.com"

        ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendSphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      home: SignupScreen(),
    //   home: const ResponsiveLayout(
    //       webScreenLayout: webScreenLayout(),
    //       mobileScreenLayout: mobileScreenLayout()));
     );
  }
}
