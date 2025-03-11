import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';


class Register extends StatefulWidget {
  // Register({super.key});
  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Perpetual Motion'),
        actions: <Widget>[
          TextButton.icon(
            icon:Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey, //access validation from this form key, track the status of our form
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                // the null safety is a must by the new version of Dart
                validator: (val) => val!.isEmpty ? 'Enter an email' : null, // valid only it is empty(return null)
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
            SizedBox(height: 20.0),
            TextFormField(
              obscureText: true,
              validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                if (_formKey.currentState!.validate()) {
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                  if (result == null) {
                    setState(() => error = 'Please supply a valid email');
                  }
                } // validate our form based on its current state
              }
            ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
      );
  }
}