import 'package:flutter/material.dart';
import 'package:pharmacy_flutter/screens/dashboard_screen.dart';

class RoleSelectionForm extends StatefulWidget {
  const RoleSelectionForm(
      {super.key, required this.userRoles, this.user, this.token});

  final List<dynamic> userRoles; // Ensure it's a list
  final Map<String, dynamic>? user;
  final String? token;

  @override
  State<RoleSelectionForm> createState() => _RoleSelectionFormState();
}

class _RoleSelectionFormState extends State<RoleSelectionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;

  void onSelectionSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedRoleDetails = widget.userRoles
        .firstWhere((role) => role['roleId'].toString() == _selectedRole);

    print("Selected Role : $_selectedRole");
    print("Selected Role Details : $selectedRoleDetails");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  user: widget.user,
                  token: widget.token,
                  userRole: selectedRoleDetails,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Select a Role',
                border: OutlineInputBorder(),
              ),
              items: widget.userRoles.map<DropdownMenuItem<String>>((role) {
                return DropdownMenuItem<String>(
                  value: role['roleId'].toString(), // Ensure roleId is a string
                  child: Text(role['roleDescription'] ?? 'Unknown Role'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a role' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onSelectionSubmit();
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
