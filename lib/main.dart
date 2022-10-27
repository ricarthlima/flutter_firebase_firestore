import 'package:flutter/material.dart';
import 'firestore/screens/listin_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Listin',
      home: ListinScreen(),
    );
  }
}
