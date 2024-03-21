import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  bool _isActive = true;

  Future<void> _addEmployee() async {
    final name = _nameController.text;
    final startDate = DateTime.parse(_startDateController.text);
    final isActive = _isActive ? "true" : "false";

    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/addEmployee'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'startDate': startDate.toIso8601String(),
        'isActive': isActive,
      }),
    );

    if (response.statusCode == 201) {
      _nameController.clear();
      _startDateController.clear();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Employee added successfully'),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add employee'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 216, 101),
      appBar: AppBar(
        title: const Text('Add Employee'),
        backgroundColor: Colors.amberAccent,
        elevation: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _startDateController,
              decoration:
                  const InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
            ),
            CheckboxListTile(
              title: const Text('Is Active'),
              value: _isActive,
              onChanged: (val) => setState(() => _isActive = val!),
            ),
            ElevatedButton(
                onPressed: _addEmployee,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
                child: const Text(
                  'Add Employee',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
