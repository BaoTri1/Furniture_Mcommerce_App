import 'package:flutter/material.dart';
import 'package:furniture_mcommerce_app/views/screens/signup_screen/signup_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/boarding_screen/boarding_screen.dart';
//import 'package:furniture_mcommerce_app/views/screens/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furniture Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}
