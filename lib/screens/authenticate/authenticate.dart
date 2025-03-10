import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/sign_in.dart';
import 'package:flutter_application_1/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Register(),
    );
  }
}
