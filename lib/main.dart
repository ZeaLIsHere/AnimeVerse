import 'package:anime_verse/config/routes.dart';
import 'package:anime_verse/providers/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthNotifier())],
      child: MaterialApp.router(
        title: 'AnimeVerse',
        theme: ThemeData(fontFamily: 'Urbanist'),
        routerConfig: createRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
