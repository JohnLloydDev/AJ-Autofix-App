import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'home.dart';
import 'package:aj_autofix/screens/shopmap.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});
  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String selectedService = 'Standard Car Service';
  String carType = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final int _selectedIndex = 1;

  // Backend URL
  final String baseUrl = 'http://<your-server-ip>:<port>/api/bookings';

  // Future to create a booking
  Future<void> createBooking() async {
    final url = Uri.parse(baseUrl);
    final body = jsonEncode({
      'userId': '<user_id>', // Replace this with the actual user ID
      'service': selectedService,
      'carType': carType,
      'date': selectedDate.toIso8601String(),
      'time': selectedTime.format(context),
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        final booking = jsonDecode(response.body);
        print('Booking created: $booking');
        // Additional logic for success (e.g., show a success message)
      } else {
        print('Failed to create booking: ${response.body}');
        // Handle error (e.g., show an error message)
      }
    } catch (error) {
      print('Error creating booking: $error');
      // Handle error
    }
  }

  // Future to fetch bookings
  Future<void> fetchBookings() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> bookings = jsonDecode(response.body);
        print('Fetched bookings: $bookings');
        // Store bookings in a state variable if needed
      } else {
        print('Failed to fetch bookings: ${response.body}');
        // Handle error
      }
    } catch (error) {
      print('Error fetching bookings: $error');
      // Handle error
    }
  }

  // Future to update a booking
  Future<void> updateBooking(String bookingId) async {
    final url = Uri.parse('$baseUrl/$bookingId');
    final body = jsonEncode({
      'service': selectedService,
      'carType': carType,
      'date': selectedDate.toIso8601String(),
      'time': selectedTime.format(context),
    });

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final booking = jsonDecode(response.body);
        print('Booking updated: $booking');
        // Additional logic for success
      } else {
        print('Failed to update booking: ${response.body}');
        // Handle error
      }
    } catch (error) {
      print('Error updating booking: $error');
      // Handle error
    }
  }

  // Future to delete a booking
  Future<void> deleteBooking(String bookingId) async {
    final url = Uri.parse('$baseUrl/$bookingId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Booking deleted successfully');
        // Additional logic for success
      } else {
        print('Failed to delete booking: ${response.body}');
        // Handle error
      }
    } catch (error) {
      print('Error deleting booking: $error');
      // Handle error
    }
  }

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopMap()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedService,
              items: [
                'Standard Car Service',
                'Full Car Wash',
                'Change Engine Oil',
              ].map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Services',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Type of Car & Year Model',
                hintText: 'e.g., Toyota Corolla 2020',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  carType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedTime.format(context)),
                    const Icon(Icons.access_time, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                createBooking();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('BOOK NOW'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
