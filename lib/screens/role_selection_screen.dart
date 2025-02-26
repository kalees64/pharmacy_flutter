import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/constants/color.dart';
import 'package:pharmacy_flutter/constants/environment.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';
import 'package:pharmacy_flutter/widgets/role_selection_form.dart';
import 'package:http/http.dart' as http;

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key, this.user, this.token});

  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  dynamic _userRoles = [];

  @override
  void initState() {
    _getUserRoles();
    // TODO: implement initState
    super.initState();
  }

  void _getUserRoles() async {
    final url = Uri.parse('$apiUrl/auth/role');

    final username = widget.user?['email'];

    try {
      final response = await http
          .post(url, body: json.encode({'username': username}), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("User roles : $jsonData");
        setState(() {
          _userRoles = jsonData;
        });
      } else {
        print('Failed to load roles');
      }
    } catch (e) {
      print("--Role Selection Error : $e");
    }
  }

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
                    h1("Select Role"),
                    RoleSelectionForm(
                      userRoles: _userRoles,
                      user: widget.user,
                      token: widget.token,
                    )
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
