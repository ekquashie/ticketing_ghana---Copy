import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketing_ghana/models/user.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user object
  TicketUser _userFromFirebaseUser(User user) {
    return user != null ? TicketUser(uid: user.uid) : null;
  }

  //get current user uid
  Future<String> currentUser() async {
    return (_auth.currentUser.uid);
  }

  //stream
  Stream<TicketUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //signIn email&pass
  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register email&pass
  Future registerEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
