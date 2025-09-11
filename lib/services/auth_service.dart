import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawfect_care/models/profile.dart';
import 'package:pawfect_care/models/user.dart' as user;
import 'package:pawfect_care/utils/validators.dart';
class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> register(String name,String email, String password) async {
    if (!isValidName(name)) {
      throw Exception('Please enter a valid name.');
    }

    if (!isValidEmail(email)) {
      throw Exception('Please enter a valid email address.');
    }

    if (!isValidPassword(password)) {
      throw Exception('Password must be at least 6 characters long.');
    }

    try {
      final result = await firestore.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await result.user?.updateDisplayName(name);
      await result.user?.reload();
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('This email is already in use.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        default:
          throw Exception('Registration failed. Please try again.');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String name
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await firestore.collection('users').doc(userCredential.user!.uid).set(user.User(email: email, name: name, password: password, profile:Profile(
        uid: userCredential.user!.uid,
        
      ),userId: userCredential.user!.uid).toMap());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
