// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

const _baseUrl = 'http://127.0.0.1:8000';

Future<Map<String, dynamic>> postWithAuth(String path, Map body) async {
  final token = await AuthService.getToken();
  final resp = await http.post(
    Uri.parse('$_baseUrl$path'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );
  if (resp.statusCode == 200) return jsonDecode(resp.body);
  throw Exception('Error ${resp.statusCode}: ${resp.body}');
}

Future<List<dynamic>> getWithAuth(String path) async {
  final token = await AuthService.getToken();
  final resp = await http.get(
    Uri.parse('$_baseUrl$path'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (resp.statusCode == 200) return jsonDecode(resp.body);
  throw Exception('Error ${resp.statusCode}: ${resp.body}');
}

