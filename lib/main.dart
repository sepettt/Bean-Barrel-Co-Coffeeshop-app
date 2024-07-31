import 'dart:io';

import 'package:bean_barrel_co/pages/order_detail_page.dart';
import 'package:bean_barrel_co/pages/ordered_page.dart';
import 'package:bean_barrel_co/pages/splash_srceen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bean_barrel_co/pages/home_page.dart';
import 'package:bean_barrel_co/pages/login_page.dart';
import 'package:bean_barrel_co/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

Platform.isAndroid
    ? await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCt9quLV9FzwSPgCC61p-QSNyR6HC-7cPg",
          appId: "1:86520507411:android:d49d295c4426e12fde63e6",
          messagingSenderId: "86520507411",
          projectId: "bean-barrel-co-e0da1",
        ),
      )

  :await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bean Barrel Co',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/auth': (context) => const AuthWrapper(),
        '/Profile': (context) => const ProfilePage(),
        '/Home': (context) => const HomePage(),
        '/Ordered':(context) => OrderedPage(),
        '/orderDetail': (context) => const OrderDetailPage(orderId: '', orderData: {}),

      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
