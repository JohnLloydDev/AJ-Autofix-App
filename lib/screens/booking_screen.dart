import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_event.dart';
import 'package:aj_autofix/bloc/service/selected_services_state.dart';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/booking_repository_impl.dart';
import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/notification_screen.dart';
import 'package:aj_autofix/screens/shopmap.dart';
import 'package:aj_autofix/screens/booking_confirmation_screen.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/widgets/date_picker_field.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  String carType = '';
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  User? user;
  String? errorMessage;

  final TextEditingController carTypeController = TextEditingController();

  final List<String> timeSlots = [
    "8:00AM-10:00AM",
    "10:00AM-12:00AM",
    "1:00PM-3:00PM",
    "3:00PM-5:00PM",
  ];

  @override
  void dispose() {
    carTypeController.dispose();
    super.dispose();
  }

  void _removeService(String serviceName) {
    context.read<SelectedServicesBloc>().add(RemoveSelectedService(serviceName));
    Fluttertoast.showToast(
      msg: "Removed $serviceName from booking",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: kAppBarGradient,
        ),
        title: const Text('Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              if (selectedTimeSlot != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                      selectedServices:
                          context.read<SelectedServicesBloc>().state.selectedServices,
                      selectedServiceCount:
                          context.read<SelectedServicesBloc>().state.selectedServiceCount,
                      selectedTimeSlot: selectedTimeSlot!,
                      bookingDate: selectedDate,
                      vehicleType: carType,
                    ),
                  ),
                );
              } 
            } else if (state is RequestError) {
              setState(() {
                errorMessage = state.error;
              });
              return;
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
                  BlocBuilder<SelectedServicesBloc, SelectedServicesState>(
                    builder: (context, selectedServicesState) {
                      return selectedServicesState.selectedServices.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedServicesState.selectedServices.length,
                              itemBuilder: (context, index) {
                                final serviceName =
                                    selectedServicesState.selectedServices[index];
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
                                                _removeService(serviceName);
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
                            );
                    },
                  ),
                  const SizedBox(height: kSpacing),
                  TextFormField(
                    controller: carTypeController,
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
                  const Text(
                    'Select Time Slot:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeSlots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      final isSelected = selectedTimeSlot == slot;
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTimeSlot = slot;
                            errorMessage = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? kMainColor : Colors.grey[200],
                          foregroundColor:
                              isSelected ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: isSelected
                                ? const BorderSide(color: kMainColor, width: 2)
                                : const BorderSide(
                                    color: Colors.grey, width: 1),
                          ),
                        ),
                        child: Text(
                          slot,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: kSpacing),
                  ElevatedButton(
                    onPressed: () {
                      if (carTypeController.text.isEmpty) {
                        setState(() {
                          errorMessage = 'Please enter the type of car.';
                        });
                        return;
                      }

                      if (selectedDate.isBefore(DateTime.now())) {
                        setState(() {
                          errorMessage = 'Please select a valid future date.';
                        });
                        return;
                      }

                      final selectedServicesState =
                          context.read<SelectedServicesBloc>().state;

                      if (selectedServicesState.selectedServices.isEmpty) {
                        setState(() {
                          errorMessage = 'Please select at least one service.';
                        });
                        return;
                      }

                      if (selectedTimeSlot == null) {
                        setState(() {
                          errorMessage = 'Please select a time slot.';
                        });
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
                        serviceType: selectedServicesState.selectedServices,
                        vehicleType: carTypeController.text,
                        time: selectedTimeSlot!,
                        date: selectedDate,
                        status: 'Pending',
                      );

                      context.read<BookingBloc>().add(CreateBooking(booking));
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: kMainColor,
                        side: const BorderSide(color: kMainColor),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
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
      bottomNavigationBar:
          BlocBuilder<SelectedServicesBloc, SelectedServicesState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 1,
            selectedItemColor: const Color(0xFF6E88A1),
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.receipt),
                    if (state.selectedServiceCount > 0)
                      Positioned(
                        right: 0,
                        top: -1,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Center(
                            child: Text(
                              '${state.selectedServiceCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Booking',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notification',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<SelectedServicesBloc>(),
                        child: const HomeScreen(
                        ),
                      ),
                    ),
                  );
                  break;
                case 1:
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopMap(
                        selectedServices:
                            context.read<SelectedServicesBloc>().state.selectedServices,
                        selectedServiceCount:
                            context.read<SelectedServicesBloc>().state.selectedServiceCount,
                      ),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => BookingBloc(BookingRepositoryImpl())
                          ..add(GetUserBooking()),
                        child: NotificationScreen(
                          selectedServices:
                              context.read<SelectedServicesBloc>().state.selectedServices,
                          selectedServiceCount:
                              context.read<SelectedServicesBloc>().state.selectedServiceCount,
                        ),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
