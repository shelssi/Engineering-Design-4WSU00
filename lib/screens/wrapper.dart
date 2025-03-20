import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/authenticate/authenticate.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either home or authenticate widget
    final user = Provider.of<MyUser?>(context);

    print("current user status： $user");
  
    if (user == null) {
      //print("User is null, showing Authenticate");
      return Authenticate(); // not signed in -> go into Sign In page
    } else {
      //print("User is signed in, UID: ${user.uid}, showing Home");
      return Home(); // signed in -> into Home page
    }
  }
}