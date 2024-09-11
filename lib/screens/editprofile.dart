import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Implement save functionality here
              Navigator.pop(context);
            },
            child: const Text(
              'SAVE',
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
            _buildGenderRadioButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: initialValue,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderRadioButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              _buildGenderRadioButton('Male'),
              _buildGenderRadioButton('Female'),
              _buildGenderRadioButton('Other'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderRadioButton(String gender) {
    return Expanded(
      child: Row(
        children: [
          Radio<String>(
            value: gender,
            groupValue: 'Male', // Initially selected value
            onChanged: (String? value) {
              // Handle the gender change here
            },
          ),
          Text(gender),
        ],
      ),
    );
  }
}
