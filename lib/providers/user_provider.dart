import 'package:flutter/cupertino.dart';
import 'package:friendsphere/resources/auth_methods.dart';
import 'package:friendsphere/models/user.dart';
class UserProvider with ChangeNotifier{
  User? _user;
   User get getUser => _user!;
  Future<void> refreshUser()async{
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }




}