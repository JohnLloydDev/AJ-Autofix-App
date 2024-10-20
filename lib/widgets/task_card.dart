import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String carname;
  final String status;
  final Color statusColor;
  final VoidCallback? onReviewPressed;

  TaskCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.subtitle,
    this.onReviewPressed,
    required this.date,
    required this.time,
    required this.carname,
  });

  final List<String> statusSteps = [
    'Pending',
    'Approved',
    'Completed',
  ];

  int _getStatusIndex(String status) {
    return statusSteps.indexOf(status);
  }

  @override
  Widget build(BuildContext context) {
    final int currentStep = _getStatusIndex(status);

    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(1.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.blue),
                const SizedBox(width: 8.0),
                const Text(
                  'Vehicle: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  carname,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8.0),
                const Text(
                  'Date: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8.0),
                const Text(
                  'Time Slot: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Row(
              children: [
                Icon(Icons.build, color: Colors.blue),
                SizedBox(width: 8.0),
                Text(
                  'Services: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16.0),

            // Only show the status stepper if the status is not 'Rejected'
            if (status != 'Rejected') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < statusSteps.length; i++) ...[
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: i <= currentStep
                              ? Colors.green
                              : Colors.grey.shade400,
                          child: i <= currentStep
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 12)
                              : null,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          statusSteps[i],
                          style: TextStyle(
                            fontSize: 12,
                            color: i <= currentStep
                                ? Colors.black
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    if (i != statusSteps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2.0,
                          color: i < currentStep
                              ? Colors.green
                              : Colors.grey.shade400,
                        ),
                      ),
                  ]
                ],
              ),
              const SizedBox(height: 16.0),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (status == 'Completed')
                  ElevatedButton(
                    onPressed: onReviewPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 146, 176, 204)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        color: Color.fromARGB(255, 146, 176, 204),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
