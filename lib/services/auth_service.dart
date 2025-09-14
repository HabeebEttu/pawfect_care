import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawfect_care/models/profile.dart';
import 'package:pawfect_care/models/role.dart';
import 'package:pawfect_care/models/user.dart' as user;
class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmailAndPassword(
      String email,
      String password,
      String name, {
        required Role role,
      }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(
        user.User(
          userId: userCredential.user!.uid,
          email: email,
          name: name,
          role: role,
          profile: Profile(uid: userCredential.user!.uid),
        ).toMap(),
      );

      return userCredential;
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



  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        default:
          throw Exception('Login failed. Please try again.');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
