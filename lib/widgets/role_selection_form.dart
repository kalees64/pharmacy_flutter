import 'package:flutter/material.dart';

class RoleSelectionForm extends StatefulWidget {
  const RoleSelectionForm({super.key});

  @override
  State<RoleSelectionForm> createState() => _RoleSelectionFormState();
}

class _RoleSelectionFormState extends State<RoleSelectionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole;

  final List<String> _roles = ['Admin', 'User', 'Manager', 'Guest'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected Role: $_selectedRole')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 15,
            children: [
              DropdownButtonFormField(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Select a Role',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
