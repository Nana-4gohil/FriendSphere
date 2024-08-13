import 'package:flutter/material.dart';
import 'package:friendsphere/utils/global_variable.dart';
class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraints){
          if(constraints.maxWidth > webSreenSize){
              //web scress
             return webScreenLayout;
          }
          return mobileScreenLayout;
        }
    );
  }
}
