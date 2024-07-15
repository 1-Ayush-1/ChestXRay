import 'package:flutter/material.dart';


class MyDummy extends StatefulWidget {
  const MyDummy({super.key});

  @override
  State<MyDummy> createState() => _MyDummyState();
}

class _MyDummyState extends State<MyDummy> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: Center(
          child: Text(
            'Welcome to My App!',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}