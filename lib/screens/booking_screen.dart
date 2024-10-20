import 'package:aj_autofix/bloc/notifications/Notification_bloc.dart';
import 'package:aj_autofix/bloc/user/user_bloc.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/models/booking_confirmation_arguments.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_event.dart';
import 'package:aj_autofix/bloc/service/selected_services_state.dart';
import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/widgets/date_picker_field.dart';
import 'package:go_router/go_router.dart';

class BookingScreen extends StatefulWidget {
  final String userId;

  const BookingScreen({super.key, required this.userId});

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
    "8:00 AM - 10:00 AM",
    "10:00 AM - 12:00 PM",
    "1:00 PM - 3:00 PM",
    "3:00 PM - 5:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().fetchNotificationCount();
  }

  @override
  void dispose() {
    carTypeController.dispose();
    super.dispose();
  }

  void _removeService(String serviceName) {
    context
        .read<SelectedServicesBloc>()
        .add(RemoveSelectedService(serviceName));
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
            decoration: kAppBar,
          ),
          title: const Text(
            'Booking',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: BlocConsumer<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingSuccess) {
                if (selectedTimeSlot != null) {
                  GoRouter.of(context).go(
                    '/confirmBooking',
                    extra: BookingConfirmationArguments(
                      selectedServices: context
                          .read<SelectedServicesBloc>()
                          .state
                          .selectedServices,
                      selectedServiceCount: context
                          .read<SelectedServicesBloc>()
                          .state
                          .selectedServiceCount,
                      selectedTimeSlot: selectedTimeSlot!,
                      bookingDate: selectedDate,
                      vehicleType: carType,
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
                return const CustomLoading();
              }

              final authState = context.watch<UserBloc>().state;

              if (authState is UserDataLoadedByAuth) {
                user = authState.user;
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
                                itemCount: selectedServicesState
                                    .selectedServices.length,
                                itemBuilder: (context, index) {
                                  final serviceName = selectedServicesState
                                      .selectedServices[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      width: 350,
                                      height: 50,
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                      decoration: InputDecoration(
                        labelText: 'Type of Car & Year Model',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 107, 105, 105),
                        ),
                        hintText: 'e.g., Toyota Corolla 2020',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 107, 105, 105)
                              .withOpacity(0.7),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                                255, 146, 176, 204),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 146, 176,
                                204),
                            width: 2.0, 
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 146, 176,
                                204),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: const Color.fromARGB(
                          255, 146, 176, 204),
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
                                  ? const BorderSide(
                                      color: kMainColor, width: 2)
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
                            errorMessage =
                                'Please select at least one service.';
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
        ));
  }
}
