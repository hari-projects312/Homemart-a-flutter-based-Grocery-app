import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'user_data.dart'; // Make sure this file has registeredUsers defined as shown

void main() {
  runApp(const HomeMartApp());
}

class HomeMartApp extends StatelessWidget {
  const HomeMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeMart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(registeredUsers: registeredUsers),
        '/signup': (context) => SignupPage(registeredUsers: registeredUsers),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
