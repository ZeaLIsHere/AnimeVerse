import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  AuthServices._internal();
  static final AuthServices _instance = AuthServices._internal();
  factory AuthServices() => _instance;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error Sign In: $e');
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error Sign Up: $e');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      }

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Error Google Sign In: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error Password Reset: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }
}

typedef AuthService = AuthServices;
