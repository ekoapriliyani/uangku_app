import 'package:flutter/material.dart';
import 'package:uangku_app/pages/main_page.dart';
import 'package:uangku_app/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
