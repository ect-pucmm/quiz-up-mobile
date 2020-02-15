import 'package:flutter/material.dart';
import 'package:quiz_up/question_view.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Up!'),
      ),
      body: Center(
        child: Question( team: "My Team" ),
      ),
    );
  }
}