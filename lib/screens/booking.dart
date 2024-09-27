import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart'; 
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'shopmap.dart';

class BookingScreen extends StatefulWidget {
  final List<String> selectedServices;

  const BookingScreen({
    super.key,
    required this.selectedServices,
  });

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  String carType = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  late TextEditingController serviceController;

  User? user;

  @override
  void initState() {
    super.initState();
    serviceController =
        TextEditingController(text: widget.selectedServices.join(', '));
  }

  @override
  void dispose() {
    serviceController.dispose();
    super.dispose();
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final parsedTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return '${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFDCDCDC),
                Color(0xFF6E88A1),
              ],
            ),
          ),
        ),
        title: const Text('Booking'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is RequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final authState = context.watch<AuthBloc>().state;

            if (authState is AuthSuccessWithRole) {
              user = authState.user;
            }

            if (user == null) {
              return const Center(child: Text("User not logged in"));
            }

            return Column(
              children: [
                TextFormField(
                  controller: serviceController,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    hintText: 'e.g., Standard Car Service',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
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
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
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
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedTime = picked;
                      });
                    }
                  },
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
                  onPressed: () async {
                    if (carType.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the type of car.'),
                        ),
                      );
                      return;
                    }

                    if (user == null || user!.id.isEmpty) {
                      return;
                    }

                    final booking = Booking(
                      userId: user!.id,
                      serviceType: widget.selectedServices,
                      vehicleType: carType,
                      time: formatTimeOfDay(selectedTime),
                      date: selectedDate,
                      status: 'Pending',
                    );

                    context.read<BookingBloc>().add(CreateBooking(booking));
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
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
        onTap: (index) {
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
        },
      ),
    );
  }
}