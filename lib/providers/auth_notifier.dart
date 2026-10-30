import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../services/auth/auth_services.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthNotifier() {
    if (Firebase.apps.isNotEmpty) {
      _authServices.authStateChanges.listen((user) {
        _user = user;
        notifyListeners();
      });
    }
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    if (Firebase.apps.isEmpty) {
      _errorMessage = 'Firebase belum siap. Tambahkan google-services.json.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authServices.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Sign in gagal';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    if (Firebase.apps.isEmpty) {
      _errorMessage = 'Firebase belum siap. Tambahkan google-services.json.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authServices.signUp(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Sign up gagal';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authServices.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
