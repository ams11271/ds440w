// prediction_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure this file is in the same folder

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController ageController = TextEditingController();
  final TextEditingController hypertensionController = TextEditingController();
  final TextEditingController heartDiseaseController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController bloodGlucoseController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController smokingHistoryController = TextEditingController();

  String predictionResult = "";

  void _predict() async {
    if (_formKey.currentState!.validate()) {
      // Build input data from the form values
      final inputData = {
        'age': double.parse(ageController.text),
        'hypertension': int.parse(hypertensionController.text),
        'heart_disease': int.parse(heartDiseaseController.text),
        'bmi': double.parse(bmiController.text),
        'HbA1c_level': double.parse(hba1cController.text),
        'blood_glucose_level': double.parse(bloodGlucoseController.text),
        'gender': genderController.text,
        'smoking_history': smokingHistoryController.text,
      };

      try {
        int prediction = await getPrediction(inputData);
        setState(() {
          // Assuming 1 means diabetic and 0 means not diabetic
          predictionResult = prediction == 1 ? "This person is Diabetic" : "This person is not diabetic";
        });
      } catch (e) {
        setState(() {
          predictionResult = "Error: ${e.toString()}";
        });
      }
    }
  }

  @override
  void dispose() {
    ageController.dispose();
    hypertensionController.dispose();
    heartDiseaseController.dispose();
    bmiController.dispose();
    hba1cController.dispose();
    bloodGlucoseController.dispose();
    genderController.dispose();
    smokingHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diabetes Predictor")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter age" : null,
              ),
              TextFormField(
                controller: hypertensionController,
                decoration: InputDecoration(labelText: "Hypertension (0 or 1)"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter hypertension value" : null,
              ),
              TextFormField(
                controller: heartDiseaseController,
                decoration: InputDecoration(labelText: "Heart Disease (0 or 1)"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter heart disease value" : null,
              ),
              TextFormField(
                controller: bmiController,
                decoration: InputDecoration(labelText: "BMI"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter BMI" : null,
              ),
              TextFormField(
                controller: hba1cController,
                decoration: InputDecoration(labelText: "HbA1c Level"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter HbA1c level" : null,
              ),
              TextFormField(
                controller: bloodGlucoseController,
                decoration: InputDecoration(labelText: "Blood Glucose Level"),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? "Please enter blood glucose level" : null,
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: "Gender"),
                validator: (value) => value == null || value.isEmpty ? "Please enter gender" : null,
              ),
              TextFormField(
                controller: smokingHistoryController,
                decoration: InputDecoration(labelText: "Smoking History"),
                validator: (value) => value == null || value.isEmpty ? "Please enter smoking history" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predict,
                child: Text("Predict"),
              ),
              SizedBox(height: 20),
              Text(
                predictionResult,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

