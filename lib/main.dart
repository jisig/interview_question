import 'package:flutter/material.dart';
import 'package:test_code/test_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestCode(),
      debugShowCheckedModeBanner: false,
    );
  }
}
