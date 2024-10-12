// lib/main.dart
import 'package:flutter/material.dart';
// import 'package:individual_asessment/data/test.dart';
import 'package:individual_asessment/pages/home_page.dart';
// import 'package:http/http.dart' as http;
// import 'package:individual_asessment/data/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
