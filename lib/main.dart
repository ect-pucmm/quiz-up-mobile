import 'package:flutter/material.dart';
import './publisher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Up!',
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<_HomePage> {
  bool isAvailableBtn;

  @override
  void initState() {
    isAvailableBtn = true; //Change to false when sub is correctly implemented
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Up!'),
        backgroundColor: Colors.green[600],
      ),
      body: Center(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height / 2),
          width: double.infinity,
          child: FloatingActionButton(
            onPressed: isAvailableBtn ?
                () => {PublishAnswer('Team A '), _DeactivateBtn()}
                : null,
            backgroundColor: Colors.deepOrange,
            child: Icon(Icons.block),
          ),
        ),
      ),
    );
  }

  void ActivateBtn() {
    setState(() {
      isAvailableBtn = true;
    });
  }

  void _DeactivateBtn() {
    setState(() {
      isAvailableBtn = false;
    });
  }
}
