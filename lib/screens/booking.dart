import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import 'shopmap.dart';
import 'login_screen.dart';

const double kPadding = 16.0;
const double kSpacing = 16.0;
const Color kPrimaryColor = Colors.lightBlue;
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(8.0));

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

  User? user;

  @override
  void initState() {
    super.initState();
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final parsedTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm').format(parsedTime);
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
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingConfirmationScreen(),
                ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("User not logged in"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Services:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    child: widget.selectedServices.isNotEmpty
                        ? ListView.builder(
                            itemCount: widget.selectedServices.length,
                            itemBuilder: (context, index) {
                              final serviceName = widget.selectedServices[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  width: 350,
                                  height: 50,
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              serviceName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.selectedServices
                                                    .removeAt(index);
                                              });
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Removed $serviceName from booking",
                                                toastLength:
                                                    Toast.LENGTH_SHORT,
                                                gravity:
                                                    ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    Colors.black54,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            },
                                            tooltip: 'Remove Service',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text(
                            'No services selected.',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  const SizedBox(height: kSpacing),
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
                  const SizedBox(height: kSpacing),
                  DatePickerField(
                    selectedDate: selectedDate,
                    onDateSelected: (picked) {
                      if (picked.isBefore(DateTime.now())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a future date.'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        selectedDate = picked;
                      });
                    },
                  ),
                  const SizedBox(height: kSpacing),
                  TimePickerField(
                    selectedTime: selectedTime,
                    onTimeSelected: (picked) {
                      setState(() {
                        selectedTime = picked;
                      });
                    },
                  ),
                  const SizedBox(height: kSpacing),
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

                      if (selectedDate.isBefore(DateTime.now())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a valid future date.'),
                          ),
                        );
                        return;
                      }

                      if (widget.selectedServices.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select at least one service.'),
                          ),
                        );
                        return;
                      }

                      if (user == null || user!.id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'User not logged in. Please log in to proceed.'),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
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
                      backgroundColor: kPrimaryColor,
                      side: const BorderSide(color: kPrimaryColor),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'BOOK NOW',
                      semanticsLabel: 'Book your selected services now',
                    ),
                  ),
                ],
              ),
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
              // Already on Booking screen
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

class DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
    );
  }
}

class TimePickerField extends StatelessWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerField({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Time',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
    );
  }
}

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 100),
            const SizedBox(height: 20),
            const Text(
              'Your booking has been successfully placed!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
