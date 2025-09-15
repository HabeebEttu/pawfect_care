import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';
import 'package:pawfect_care/models/user.dart';
import 'package:pawfect_care/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        final user = await _userService.fetchUser(firebaseUser.uid);
        _setUser(user);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(User user) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _userService.updateUser(user);
      _setUser(user);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
