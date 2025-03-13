import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// 更新用户数据
  Future<void> updateUserData(String userId, bool heatingElementState, double temperatureC, bool valveState) async {
    try {
      await _database.child(userId).set({
        "heatingElementState": heatingElementState,
        "temperatureC": temperatureC,
        "valveState": valveState,
      });
      print("！");
    } catch (e) {
      print("  $e");
    }
  }

  /// 获取用户数据
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DatabaseEvent event = await _database.child(userId).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null && snapshot.value is Map) {
        print(" ${snapshot.value}");
        return Map<String, dynamic>.from(snapshot.value as Map);
      } else {
        print("");
        return null;
      }
    } catch (e) {
      print(" $e");
      return null;
    }
  }
}
