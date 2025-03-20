import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseManager {
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://engineer-design-default-rtdb.europe-west1.firebasedatabase.app/',
  );

// initialzie user data
Future<void> initializeUserData(String uid, MyUser? currentUser) async {
    DatabaseReference userParentRef = _database.ref().child('user');
    DataSnapshot parentSnapshot = await userParentRef.get();
    if (!parentSnapshot.exists) {
      await userParentRef.set({});
      //print("Created empty user parent node");
    }
    DatabaseReference userRef = _database.ref().child('user/$uid');
    // Check if the user exists
    DataSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      // Create default data if user is null
      await userRef.set({
        'heatingElementState': false,
        'temperatureC': 0.0,
        'valveState': false,
      });
      //print("Initialized data for user: $uid");
    }

    // // store the metadata of user into users list
    // DatabaseReference usersRef = FirebaseDatabase.instance
    //     .ref()
    //     .child('users/$uid');
    // await usersRef.set({
    //   'email': currentUser?.email ?? 'unknown',
    //   'createdAt': DateTime.now().toIso8601String(),
    // });
  }

// Listen to temperature data changes
Stream<DatabaseEvent> listenToTemperature(String user) {
  DatabaseReference tempRef = _database.ref().child('user/$user/temperatureC');
  return tempRef.onValue;
}

// Listen to valve state changes
Stream<DatabaseEvent> listenToValveState(String user) {
  DatabaseReference valveRef = _database.ref().child('user/$user/valveState');
  return valveRef.onValue;
}

// Listen to heating element state changes
Stream<DatabaseEvent> listenToHeatingElementState(String user) {
  DatabaseReference heatingRef = _database.ref().child('user/$user/heatingElementState');
  return heatingRef.onValue;
}


// upload the temperature, back-up function
Future<void> uploadTemperature(String user, double temperature) async {
  try {
    DatabaseReference tempRef = _database.ref();
    await tempRef.child('user/$user/temperatureC').set(temperature);
  } catch (e) {
    print("Error uploading temperature: $e");
  }
}

  // upload the valve state 
  Future<void> uploadValveState(String user, bool state) async {
    try {
      DatabaseReference valveRef = _database.ref();
      await valveRef.child('user/$user/valveState').set(state);
    } catch (e) {
      print("Error uploading valve state: $e");
    }
  }

  // upload the heatingElement state
Future<void> uploadHeatingElementState(String user, bool state) async {
  try {
    DatabaseReference heatingRef = _database.ref();
    await heatingRef.child('user/$user/heatingElementState').set(state);
  } catch (e) {
    print("Error uploading heating element state: $e");
  }
}

}


