import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Perpetual Motion'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
            SizedBox(height: 20.0),
            TextFormField(
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              }
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pink), 
                foregroundColor: WidgetStateProperty.all(Colors.white), 
              ),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white
                ),
              ),
              onPressed: () async {
                
              }
            )
              
            ],
          ),
        ),
      ),
      );
  }
}