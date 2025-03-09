import 'package:firebase_auth/firebase_auth.dart';


/*
 * Define all different methods that are going to interact with Firebase authors
 */
class AuthService {

  // instance to communicate with Firebase auth on the backend 
  // private (_)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      // return an auth result, but now renamed to UserCredential
      // FirebaseUser has been renamed to User
      UserCredential userCre = await _auth.signInAnonymously();
      User? user = userCre.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // 注册用户
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // 登录用户
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // 获取当前用户
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get the info the user
  void getUserProfile() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Name: ${user.displayName}");
      print("Email: ${user.email}");
      print("Photo URL: ${user.photoURL}");
    }
}

  // 更新用户信息
  Future<void> updateUserProfile(String name, String photoUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.updatePhotoURL(photoUrl);
      await user.reload();
    }
  }

  // Set email for users
  Future<void> updateEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateEmail(newEmail);
      print("Email updated!");
    }
}

  // Send verification email
  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Verification email sent!");
    }
}

  // Set user password
  Future<void> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      print("Password updated!");
    }
}

  // Sign out
  Future<void> logout() async {
    await _auth.signOut();
  }
}
