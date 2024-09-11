import 'package:aj_autofix/screens/editprofile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the UpdateProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
              );
            },
            child: const Text(
              'EDIT',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            _buildProfileDetail('First Name', 'Ayad'),
            _buildProfileDetail('Last Name', 'Muhammad'),
            _buildProfileDetail('Email', 'abc123@gmail.com'),
            _buildProfileDetail('Phone Number', '+9243873374'),
            _buildProfileDetail('Gender', 'Male'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: value,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
