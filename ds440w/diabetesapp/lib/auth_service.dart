import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const _baseUrl = 'http://127.0.0.1:8000';
final _storage = FlutterSecureStorage();

class AuthService {
  static Future<void> signup(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/users/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Signup failed: ${resp.body}');
    }
  }

  static Future<void> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      await _storage.write(key: 'token', value: data['access_token']);
    } else {
      throw Exception('Login failed: ${resp.body}');
    }
  }

  static Future<String?> getToken() => _storage.read(key: 'token');

  static Future<void> logout() => _storage.delete(key: 'token');
}
