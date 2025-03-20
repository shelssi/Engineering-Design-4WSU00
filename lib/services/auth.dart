import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/user.dart';


/*
 * Define all different methods that are going to interact with Firebase authors
 */
class AuthService {

  // instance to communicate with Firebase auth on the backend 
  // private (_)
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create MyUser obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid, email: user.email) : null;
  }

  // set authentication stream, make Flutter monitor the change of fiebase authentication
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      // return an auth result, but now renamed to UserCredential
      // FirebaseUser has been renamed to User
      UserCredential userCre = await _auth.signInAnonymously();
      User? user = userCre.user;
      return _userFromFirebaseUser(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut()
   async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // SignIn with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
