import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import 'dart:convert';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  Future<List<Employee>>? _employees;

  @override
  void initState() {
    super.initState();
    _employees = _fetchEmployees();
  }

  Future<List<Employee>> _fetchEmployees() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:4000/getEmployees'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 216, 101),
      appBar: AppBar(
        title: const Text('Employee List'),
        backgroundColor: Colors.amberAccent,
        elevation: 20,
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                final isExperienced =
                    DateTime.now().difference(employee.startDate).inDays >=
                        365 * 5;
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 2)),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/profile.png"),
                    ),
                  ),
                  title: Text(employee.name),
                  subtitle: Text(employee.isActive ? 'Active' : 'Inactive'),
                  trailing: isExperienced && employee.isActive
                      ? const Icon(Icons.flag, color: Colors.green)
                      : const Icon(Icons.flag, color: Colors.red),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          // Show a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
