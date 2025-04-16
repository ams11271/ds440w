import 'package:flutter/material.dart';
import '../auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService.signup(email, password);
        Navigator.of(context).pop(); // back to login
      } catch (e) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (v) => email = v,
                    validator: (v) => v!.isEmpty ? 'Enter email' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (v) => password = v,
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.length < 6) ? 'Password ≥ 6 chars' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _submit, child: const Text('Sign Up')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
