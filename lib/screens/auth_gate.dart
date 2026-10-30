import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_services.dart';
import 'profile_screen.dart';
import 'signin_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.isEmpty) {
      return const SignInScreen();
    }

    final AuthService auth = AuthService();
    return StreamBuilder<User?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ProfileScreen();
        } else {
          return const SignInScreen();
        }
      },
    );
  }
}
