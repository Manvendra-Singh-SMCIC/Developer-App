// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_local_variable, unnecessary_const

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GithubPageScreen extends StatefulWidget {
  @override
  _GithubPageScreenState createState() => _GithubPageScreenState();
}

class _GithubPageScreenState extends State<GithubPageScreen> {
  final TextEditingController _repositoryNameController =
      TextEditingController();
  final TextEditingController _repositoryDescriptionController =
      TextEditingController();
  final TextEditingController _AddCollaboratorController =
      TextEditingController();
  String selectedOption = "";

  List<String> items = ['None', 'Adiwait4it04', 'Manvendra-Singh-SMCIC'];
  String dropdownValue = 'None';

  Future<void> addCollaborator() async {
    const String username = 'Adiwait4it04';
    const String token = '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';
    String repoName = _repositoryNameController.text;
    String collab = _AddCollaboratorController.text;

    String apiUrl =
        "https://api.github.com/repos/$username/$repoName/collaborators/$dropdownValue";
    String authHeaderValue = "token $token";

    try {
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
        },
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        print('Collaborator added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Collaborator invitation sent successfully"),
          ),
        );
      } else {
        print('Failed to add collaborator');
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Collaborator invitation failed"),
          ),
        );
      }
    } catch (e) {
      print('Failed to connect to the server');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to connect to the server"),
        ),
      );
    }
  }

  Future<void> _createRepository() async {
    const String username = 'Adiwait4it04';
    const String token = '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';

    const String apiUrl = 'https://api.github.com/user/repos';

    final Map<String, dynamic> repositoryData = {
      'name': _repositoryNameController.text,
      'description': _repositoryDescriptionController.text,
      'private': false,
    };

    final String jsonData = json.encode(repositoryData);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Created a new repository"),
        ),
      );
    } else if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create a new repository"),
        ),
      );
    } else {
      // Failed to create repository
      print('Failed to create repository. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Settings'),
        backgroundColor: const Color(0xFF006FFD),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _repositoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Repository Name',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFF006FFD)), //<-- SEE HERE
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _repositoryDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Repository Description',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFF006FFD)), //<-- SEE HERE
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: _createRepository,
                style:
                    ElevatedButton.styleFrom(primary: const Color(0xFF006FFD)),
                child: const Text(
                  'Create Repository',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFF006FFD)), //<-- SEE HERE
                  ),
                ),
                value: dropdownValue,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue ?? '';
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: addCollaborator,
                style:
                    ElevatedButton.styleFrom(primary: const Color(0xFF006FFD)),
                child: const Text(
                  'Add Collaborator',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
