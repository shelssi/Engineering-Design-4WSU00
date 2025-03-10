import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Perpetual Motion'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log out'),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
    );
  }
}