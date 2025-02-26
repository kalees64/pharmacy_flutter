import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';
import 'package:pharmacy_flutter/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    Image.asset(
                      'assets/pharmacy_logo.png',
                      width: 250,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    h1("Login"),
                    LoginForm()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
