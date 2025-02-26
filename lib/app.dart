import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/screens/login_screen.dart';
import 'package:pharmacy_flutter/screens/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: LoginScreen());
//   }
// }

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Widget startScreen = LoginScreen();

  @override
  void initState() {
    checkUserLogin();
    // TODO: implement initState
    super.initState();
  }

  void checkUserLogin() async {
    final SharedPreferences localStorage =
        await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    var token = localStorage.getString('token');
    if (user != null && token != null) {
      setState(() {
        startScreen = RoleSelectionScreen(
          user: json.decode(user),
          token: token,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: startScreen);
  }
}
