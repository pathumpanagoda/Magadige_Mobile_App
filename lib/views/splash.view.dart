import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magadige/modules/auth/login.dart';
import 'package:magadige/modules/home/view.dart';
import 'package:magadige/utils/index.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (FirebaseAuth.instance.currentUser == null) {
        context.navigator(context, const LoginView(), shouldBack: false);
      } else {
        context.navigator(context, const HomeView(), shouldBack: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}
