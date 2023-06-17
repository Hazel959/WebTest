import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'databse_helper.dart';

class PatientFormScreen extends StatelessWidget {
  PatientFormScreen({super.key});
  @override
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  void _submitForm(BuildContext context) async {
    final int id = int.parse(_idController.text);
    final String code = _codeController.text;

    await DatabaseHelper.instance.insertPatient(id, code);
    // ignore: unused_element
    getDatabasePath() {
      getDatabasePath().then((path) {
        Text('Database path: $path');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient data saved')),
      );
    }

    @override
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Patient Form')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Patient ID'),
              ),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Code'),
              ),
              // ignore: avoid_print

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
