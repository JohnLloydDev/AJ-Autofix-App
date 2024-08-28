import 'package:flutter/material.dart';

class UserPendingRequest extends StatefulWidget {
  const UserPendingRequest({super.key});

  @override
  State<UserPendingRequest> createState() => _UserPendingRequestState();
}

class _UserPendingRequestState extends State<UserPendingRequest> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white, // Set your desired color
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            TaskCard(
              title: 'Change oil, car wash...',
              status: 'Pending',
              statusColor: Colors.grey,
            ),
            TaskCard(
              title: 'Machine fitter needed.',
              status: 'Confirmed',
              statusColor: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;

  const TaskCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}