import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://127.0.0.1:8000";

Future<int> getPrediction(Map<String, dynamic> healthcareData) async {
  final url = Uri.parse('$baseUrl/predict');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(healthcareData),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    return result['prediction'];
  } else {
    throw Exception('Failed to load prediction: ${response.statusCode}');
  }
}
