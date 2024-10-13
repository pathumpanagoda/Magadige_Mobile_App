import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:magadige/views/splash.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashView(),
      theme: ThemeData(
        primarySwatch: Colors.blue, // Defines primary theme color
        scaffoldBackgroundColor:
            Colors.white, // Background color for all scaffolds
        textTheme: const TextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Button background color
          textTheme: ButtonTextTheme.primary, // Text color in buttons
        ),
      ),
    );
  }
}
