import 'package:flutter/material.dart';
import 'api_service.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController ageController = TextEditingController();
  final TextEditingController hypertensionController = TextEditingController();
  final TextEditingController heartDiseaseController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController bloodGlucoseController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController smokingHistoryController = TextEditingController();

  String predictionResult = '';
  List<dynamic> recommendations = [];

  void _predict() async {
    if (_formKey.currentState!.validate()) {
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
        final result = await getPrediction(inputData);
        setState(() {
          predictionResult = '${result['risk_level']} — ${result['message']}';
          recommendations = result['recommendations'];
        });
      } catch (e) {
        setState(() {
          predictionResult = 'Error: ${e.toString()}';
          recommendations = [];
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
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
              _buildTextField("Age", ageController, isNumber: true),
              _buildTextField("Hypertension (0 or 1)", hypertensionController, isNumber: true),
              _buildTextField("Heart Disease (0 or 1)", heartDiseaseController, isNumber: true),
              _buildTextField("BMI", bmiController, isNumber: true),
              _buildTextField("HbA1c Level", hba1cController, isNumber: true),
              _buildTextField("Blood Glucose Level", bloodGlucoseController, isNumber: true),
              _buildTextField("Gender", genderController),
              _buildTextField("Smoking History", smokingHistoryController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predict,
                child: Text("Predict"),
              ),
              SizedBox(height: 20),
              if (predictionResult.isNotEmpty)
                Text(
                  predictionResult,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ...recommendations.map((tip) => ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text(tip),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
