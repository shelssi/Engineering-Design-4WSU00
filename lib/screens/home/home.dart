

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/managers/FirebaseManager.dart';  // 导入 FirebaseManager
import 'package:flutter_application_1/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseManager _firebaseManager = FirebaseManager();
  final AuthService _auth = AuthService();

  bool valveState = false;
  bool heatingElementState = false;
  double temperatureC = 25.0;
  String user = "user1";  // 数据库路径中的用户

  @override
  void initState() {
    super.initState();
    print("Current user: ${_auth.user}");
    _listenToTemperature();  // 监听温度数据
    _listenToValveState();  // 监听阀门状态
    _listenToHeatingElementState();  // 监听加热元件状态
  }

  // Listen to temperature data changes
  _listenToTemperature() {
    _firebaseManager.listenToTemperature(user).listen((DatabaseEvent event) {
      final tempValue = event.snapshot.value;
      if (tempValue != null) {
        setState(() {
          //print(temperatureC);
          temperatureC = tempValue.toString() as double;
          //print(temperatureC);
        });
      }
    });
  }

  // Listen to valve state changes
  _listenToValveState() {
    _firebaseManager.listenToValveState(user).listen((event) {
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
    _firebaseManager.listenToHeatingElementState(user).listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          heatingElementState = (snapshot.value as bool?) ?? false;
        });
      }
    });
  }

  // // Upload temperature data
  // _uploadTemperature(double temperature) async {
  //   await _firebaseManager.uploadTemperature(user, temperature);
  // }

  // // Upload valve state
  // _uploadValveState(bool state) async {
  //   await _firebaseManager.uploadValveState(user, state);
  // }

  // // Upload heating element state
  // _uploadHeatingElementState(bool state) async {
  //   await _firebaseManager.uploadHeatingElementState(user, state);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   // 关闭监听流
  // }

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
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Temperature: $temperatureC°C',
              //style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('Valve State: $valveState'),
            SizedBox(height: 20),
            Text('Heating Element State: $heatingElementState'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              bool newState = !valveState;
              try {
                await _firebaseManager.uploadValveState(user, newState);
                setState(() {
                  valveState = newState;
                });
              } catch (e) {
                print("Failed to update valve state: $e");
              }
            },
              child: Text("Toggle Valve State"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  heatingElementState = !heatingElementState;
                });
                _firebaseManager.uploadHeatingElementState(user,heatingElementState);
              },
              child: Text("Toggle Heating Element State"),
            ),
          ],
        ),
      ),
    );
  }
}
