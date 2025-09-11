import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawfect_care/models/profile.dart';
import 'package:pawfect_care/models/user.dart' as user;
class AuthService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
