import 'package:flutter/material.dart';
import'./main_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      title: 'Quiz Up!',
      home: MainLayout(),
    );
  }
}



