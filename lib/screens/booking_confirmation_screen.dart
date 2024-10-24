import 'package:aj_autofix/bloc/service/selected_services_bloc.dart';
import 'package:aj_autofix/bloc/service/selected_services_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/color_extensions.dart';
import 'package:aj_autofix/widgets/booking_detail_row.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final List<String> selectedServices;
  final int selectedServiceCount;
  final String selectedTimeSlot;
  final DateTime bookingDate;
  final String vehicleType;

  const BookingConfirmationScreen({
    super.key,
    required this.selectedServices,
    required this.selectedServiceCount,
    required this.selectedTimeSlot,
    required this.bookingDate,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Booking Confirmed',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                  size: 100,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Your booking has been successfully placed!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor.darken(0.2),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingDetailRow(
                        icon: Icons.directions_car,
                        label: 'Vehicle',
                        value: vehicleType,
                      ),
                      const Divider(),
                      BookingDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: DateFormat('MM/dd/yyyy').format(bookingDate),
                      ),
                      const Divider(),
                      BookingDetailRow(
                        icon: Icons.access_time,
                        label: 'Time Slot',
                        value: selectedTimeSlot,
                      ),
                      const Divider(),
                      BookingDetailRow(
                        icon: Icons.build,
                        label: 'Total Services',
                        value: '$selectedServiceCount',
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Services:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor.darken(0.1),
                          ),
                        ),
                      ),
                      ...selectedServices.map((service) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    service,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: screenWidth * 0.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SelectedServicesBloc>(context)
                        .add(ClearSelectedServices());

                    (context).push('/mainscreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kAccentColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
