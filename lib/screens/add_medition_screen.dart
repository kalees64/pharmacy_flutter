import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/widgets/add_medition_form.dart';
import 'package:pharmacy_flutter/widgets/heading_text.dart';

class AddMeditionScreen extends StatefulWidget {
  const AddMeditionScreen({super.key, this.token, this.user, this.userRole});

  final dynamic userRole;
  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<AddMeditionScreen> createState() => _AddMeditionScreenState();
}

class _AddMeditionScreenState extends State<AddMeditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarTitle("Add Medition"),
        backgroundColor: const Color.fromARGB(251, 6, 231, 14),
      ),
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
                        child: AddMedicineForm(
                          user: widget.user,
                          token: widget.token,
                          userRole: widget.userRole,
                        ),
                      ),
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
