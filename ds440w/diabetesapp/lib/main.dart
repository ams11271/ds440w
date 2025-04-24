import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(DiabetesApp());

class DiabetesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Predictor',
      debugShowCheckedModeBanner: false,         // <-- hide the DEBUG banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade50,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(
              onLoggedIn: () =>
                  Navigator.of(_).pushReplacementNamed('/dashboard'),
            ),
        '/signup': (_) => SignupScreen(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}