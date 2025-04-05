import 'package:flutter/material.dart';
import 'prediction_screen.dart'; // Import your prediction screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionScreen(),
    );
  }
}
