import 'package:flutter/material.dart';
import '../api_service.dart';

class PredictionForm extends StatefulWidget {
  final void Function(Map<String, dynamic>) onResult;
  const PredictionForm({Key? key, required this.onResult}) : super(key: key);

  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final ageC = TextEditingController();
  final hypC = TextEditingController();
  final hdC = TextEditingController();
  final bmiC = TextEditingController();
  final hba1cC = TextEditingController();
  final bgC = TextEditingController();
  final genderC = TextEditingController();
  final smokeC = TextEditingController();

  @override
  void dispose() {
    ageC.dispose();
    hypC.dispose();
    hdC.dispose();
    bmiC.dispose();
    hba1cC.dispose();
    bgC.dispose();
    genderC.dispose();
    smokeC.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final input = {
        'age': double.parse(ageC.text),
        'hypertension': int.parse(hypC.text),
        'heart_disease': int.parse(hdC.text),
        'bmi': double.parse(bmiC.text),
        'HbA1c_level': double.parse(hba1cC.text),
        'blood_glucose_level': double.parse(bgC.text),
        'gender': genderC.text,
        'smoking_history': smokeC.text,
      };
      try {
        final res =
            await postWithAuth('/predictions/predict', input);
        widget.onResult(res);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          controller: ageC,
          decoration: const InputDecoration(labelText: 'Age'),
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? 'Enter age' : null,
        ),
        TextFormField(
          controller: hypC,
          decoration:
              const InputDecoration(labelText: 'Hypertension (0 or 1)'),
          keyboardType: TextInputType.number,
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter hypertension' : null,
        ),
        TextFormField(
          controller: hdC,
          decoration:
              const InputDecoration(labelText: 'Heart Disease (0 or 1)'),
          keyboardType: TextInputType.number,
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter heart disease' : null,
        ),
        TextFormField(
          controller: bmiC,
          decoration: const InputDecoration(labelText: 'BMI'),
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? 'Enter BMI' : null,
        ),
        TextFormField(
          controller: hba1cC,
          decoration: const InputDecoration(labelText: 'HbA1c Level'),
          keyboardType: TextInputType.number,
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter HbA1c level' : null,
        ),
        TextFormField(
          controller: bgC,
          decoration:
              const InputDecoration(labelText: 'Blood Glucose Level'),
          keyboardType: TextInputType.number,
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter blood glucose level' : null,
        ),
        TextFormField(
          controller: genderC,
          decoration: const InputDecoration(labelText: 'Gender'),
          validator: (v) => v == null || v.isEmpty ? 'Enter gender' : null,
        ),
        TextFormField(
          controller: smokeC,
          decoration: const InputDecoration(labelText: 'Smoking History'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter smoking history' : null,
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _submit, child: const Text('Predict')),
      ]),
    );
  }
}
