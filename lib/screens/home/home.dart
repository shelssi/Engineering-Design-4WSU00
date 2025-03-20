import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/managers/FirebaseManager.dart';  // 导入 FirebaseManager
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/authenticate/authenticate.dart';
import 'package:flutter_application_1/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseManager _firebaseManager = FirebaseManager();
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool valveState = false;
  bool heatingElementState = false;
  double temperatureC = 0.0;
  String? user;  // the user in the database path

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _listenToTemperature();  
    _listenToValveState();  
    _listenToHeatingElementState();  
  }

  _initializeUser() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Authenticate()),
      );
    } else {
      setState(() {
        user = currentUser.uid;
      });
      print("Current user UID: $user");
      MyUser myUser = MyUser(uid: currentUser.uid, email: currentUser.email);
      await _firebaseManager.initializeUserData(user!, myUser);
    }
  }

  // Listen to temperature data changes
  _listenToTemperature() {
    if (user == null) return;
    _firebaseManager.listenToTemperature(user!).listen((DatabaseEvent event) {
      final tempValue = event.snapshot.value;
      if (tempValue != null) {
        setState(() {
          temperatureC = (tempValue is num) ? tempValue.toDouble() : double.tryParse(tempValue.toString()) ?? 0.0;
          print("Temperature updated: $temperatureC");          
        });
      }
    });
  }

  // Listen to valve state changes
  _listenToValveState() {
    if (user == null) return;
    _firebaseManager.listenToValveState(user!).listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          valveState = (snapshot.value as bool?) ?? false;
        });
      }
    });
  }

  // Listen to heating element state changes
  _listenToHeatingElementState() {
    if (user == null) return;
    _firebaseManager.listenToHeatingElementState(user!).listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          heatingElementState = (snapshot.value as bool?) ?? false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Perpetual Motion'),
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log out'),
            onPressed: () async {
              await _auth.signOut();
              // setState(() {
              //   user = null;
              // });
              // // If log out, navigate to authenticate page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => Authenticate()),
              // );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Temperature: $temperatureC°C',),
            SizedBox(height: 20),
            Text('Valve State: $valveState'),
            SizedBox(height: 20),
            Text('Heating Element State: $heatingElementState'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              bool newValveState = !valveState;
              try {
                await _firebaseManager.uploadValveState(user!, newValveState);
                setState(() {
                  valveState = newValveState;
                });
              } catch (e) {
                print("Failed to update valve state: $e");
              }
            },
              child: Text("Toggle Valve State"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool newHeatingElementState = !heatingElementState;
                try {
                  await _firebaseManager.uploadHeatingElementState(user!, newHeatingElementState);
                  setState(() {
                    heatingElementState = newHeatingElementState;
                  });
                } catch (e) {
                  print("Failed to update heating element state: $e");
                }
              },
                child: Text("Toggle Heating Element State"),
            ),
          ],
        ),
      ),
    );
  }
}
