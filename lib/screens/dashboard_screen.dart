import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/screens/add_medition_screen.dart';
import 'package:pharmacy_flutter/screens/login_screen.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.token, this.user, this.userRole});

  final dynamic userRole;
  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _navigateToAddMedicinePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => AddMeditionScreen(
                  user: widget.user,
                  token: widget.token,
                  userRole: widget.userRole,
                )));
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Image.asset('assets/pharmacy_logo.png'),
          title: navBarTitle("Dashboard"),
          actions: [
            Tooltip(
              message: "Add Medition",
              child: IconButton(
                icon: Icon(Icons.local_pharmacy_outlined),
                onPressed: () {
                  _navigateToAddMedicinePage();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logout();
              },
            )
          ],
          backgroundColor: const Color.fromARGB(251, 6, 231, 14)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              // padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.lightGreenAccent,
                  const Color.fromARGB(255, 11, 230, 18)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Column(
                spacing: 10,
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(55, 255, 255, 255),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Image.asset('assets/pharmacy_logo.png'),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
