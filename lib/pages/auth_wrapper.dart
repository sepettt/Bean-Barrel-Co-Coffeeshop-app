import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_barrel_co/pages/home_page.dart';
import 'package:bean_barrel_co/pages/login_page.dart';
import 'package:bean_barrel_co/pages/splash_srceen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoginPage();
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
