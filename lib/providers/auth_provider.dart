  import 'package:flutter/widgets.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:pawfect_care/models/role.dart';
  import 'package:pawfect_care/services/auth_service.dart';

  class AuthProvider with ChangeNotifier {
    final AuthService _authService = AuthService();

    bool _isLoading = false;
    String? _errorMessage;
    User? _user;

    bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;
    User? get user => _user;

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

    Future<void> signUp({
      required String email,
      required String password,
      required String name,
      required Role role,

    }) async {
      _setLoading(true);
      _setErrorMessage(null);

      try {
        UserCredential userCredential = await _authService
            .signUpWithEmailAndPassword(email, password, name, role: role);
        _setUser(userCredential.user);
      } on FirebaseAuthException catch (e) {
        _setErrorMessage(e.message);
      } catch (e) {
        _setErrorMessage(e.toString());
      } finally {
        _setLoading(false);
      }
    }

    Future<void> signIn({required String email, required String password}) async {
      _setLoading(true);
      _setErrorMessage(null);

      try {
        UserCredential userCredential = await _authService
            .signInWithEmailAndPassword(email, password);
        _setUser(userCredential.user);
      } on FirebaseAuthException catch (e) {
        _setErrorMessage(e.message);
      } catch (e) {
        _setErrorMessage(e.toString());
      } finally {
        _setLoading(false);
      }
    }

    Future<void> signOut() async {
      _setLoading(true);
      _setErrorMessage(null);

      try {
        await _authService.signOut();
        _setUser(null);
      } catch (e) {
        _setErrorMessage(e.toString());
      } finally {
        _setLoading(false);
      }
    }
  }
