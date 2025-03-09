import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService(); // 实例化 AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400], // 设定按钮颜色
            padding: EdgeInsets.all(10),
          ),
          child: Text('Sign in Anonymously', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            try {
              var result = await _auth.signInAnon();
              if (result != null) {
                print("Signed in anonymously: ${result.uid}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Signed in successfully!")),
                );
              } else {
                print("Anonymous sign-in failed.");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sign-in failed.")),
                );
              }
            } catch (e) {
              print("Error during sign-in: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
          },
        ),
      ),
    );
  }
}
