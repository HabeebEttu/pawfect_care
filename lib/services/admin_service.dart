import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfect_care/models/article.dart';
import 'package:pawfect_care/models/role.dart';
import 'package:pawfect_care/models/user.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AdminService();

  Future<void> setAdmin(User u) async {
    try {
      await _firestore
          .collection('users')
          .doc(u.userId)
          .set(u.copyWith(role: Role.admin).toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setPetOwner(User u) async {
    try {
      await _firestore
          .collection('users')
          .doc(u.userId)
          .update(u.copyWith(role: Role.user).toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
}
