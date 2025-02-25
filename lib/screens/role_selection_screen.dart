import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';
import 'package:pharmacy_flutter/widgets/role_selection_form.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.green,
                  Colors.lightGreenAccent,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                  h1("Select Role"),
                  RoleSelectionForm()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
