import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/wrapper.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp();
   // options: DefaultFirebaseOptions.currentPlatform,
  //print("Firebase initialized successfully");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
        child: MaterialApp(
          home: Wrapper(),
        ),
    );
  }
}

