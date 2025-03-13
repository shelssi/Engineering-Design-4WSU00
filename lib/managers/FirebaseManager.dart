import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseManager {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://engineer-design-default-rtdb.europe-west1.firebasedatabase.app/',
  );
  //DatabaseReference _databaseTemp = FirebaseDatabase.instance.ref().child('user/$user');
  
//   Stream<void> listenToTemperature(String user) {
//   DatabaseReference tempRef = _database.ref().child('user/$user/temperatureC');
  
//   return tempRef.onValue.map((DatabaseEvent event) {
//     final temperature = event.snapshot.value;

//     if (temperature != null) {
//       final double temperatureValue = temperature as double;
//       uploadTemperature(user, temperatureValue);
//     }
//   }).asBroadcastStream();
// }

// Listen to temperature data changes
Stream<DatabaseEvent> listenToTemperature(String user) {
  DatabaseReference tempRef = _database.ref().child('$user/temperatureC');
  return tempRef.onValue;
}

// Listen to valve state changes
Stream<DatabaseEvent> listenToValveState(String user) {
  DatabaseReference valveRef = _database.ref().child('$user/valveState');
  return valveRef.onValue;
}

// Listen to heating element state changes
Stream<DatabaseEvent> listenToHeatingElementState(String user) {
  DatabaseReference heatingRef = _database.ref().child('$user/heatingElementState');
  return heatingRef.onValue;
}


// 上传温度数据
Future<void> uploadTemperature(String user, double temperature) async {
  try {
    DatabaseReference tempRef = _database.ref();
    print(tempRef);
    await tempRef.child('$user/temperatureC').set(temperature);
    print(temperature);
  } catch (e) {
    print("Error uploading temperature: $e");
  }
}


  // 
  Future<void> uploadValveState(String user, bool state) async {
    try {
      DatabaseReference valveRef = _database.ref().child('$user/valveState');
      print("${valveRef.path}");
      await valveRef.set(state);
    } catch (e) {
      print("Error uploading valve state: $e");
    }
  }

  // 监听加热元件状态变化
// Stream<void> listenToHeatingElementState(String user) {
//   DatabaseReference heatingRef = _database.ref().child('user/$user/heatingElementState');
  
//   return heatingRef.onValue.map((DatabaseEvent event) {
//     final heatingState = event.snapshot.value;

//     if (heatingState != null) {
//       final bool heatingStateBool = heatingState as bool;
//       uploadHeatingElementState(user, heatingStateBool);
//     }
//   }).asBroadcastStream();
// }

// 上传加热元件状态
Future<void> uploadHeatingElementState(String user, bool state) async {
  try {
    DatabaseReference heatingRef = _database.ref().child('$user/heatingElementState');
    await heatingRef.set(state);
  } catch (e) {
    print("Error uploading heating element state: $e");
  }
}

}


