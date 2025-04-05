import 'package:flutter/material.dart';
import 'api_service.dart';  // Import the API service

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String _predictionResult = '';

  void _fetchPrediction() async {
    try {
      Map<String, dynamic> healthcareData = {
        'age': 45.0,
        'hypertension': 0,
        'heart_disease': 1,
        'bmi': 28.5,
        'HbA1c_level': 6.5,
        'blood_glucose_level': 110.0,
        'gender': 'male',
        'smoking_history': 'never'
      };

      int prediction = await getPrediction(healthcareData);
      setState(() {
        _predictionResult = 'Prediction: $prediction';
      });
    } catch (e) {
      setState(() {
        _predictionResult = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_predictionResult),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchPrediction,
              child: Text('Get Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}
