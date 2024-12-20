import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/booking_model.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminCompletedBookingsScreen extends StatefulWidget {
  const AdminCompletedBookingsScreen({super.key});

  @override
  State<AdminCompletedBookingsScreen> createState() =>
      _AdminCompletedBookingsScreenState();
}

class _AdminCompletedBookingsScreenState
    extends State<AdminCompletedBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Booking> _filteredBookings = [];

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetAllAcceptedBooking());
    _searchController.addListener(_filterBookings);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBookings() {
    final query = _searchController.text.toLowerCase();
    final bookingBloc = context.read<BookingBloc>();

    if (bookingBloc.state is BookingAcceptedLoaded) {
      final bookings =
          (bookingBloc.state as BookingAcceptedLoaded).acceptedBookings;
      setState(() {
        _filteredBookings = bookings.where((booking) {
          final fullnameMatch =
              booking.user?.fullname.toLowerCase().contains(query) ?? false;
          final vehicleTypeMatch =
              booking.vehicleType.toLowerCase().contains(query);
          return fullnameMatch || vehicleTypeMatch;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Services'),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 241, 241),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search bookings',
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                borderRadius: BorderRadius.circular(8.0),
                backgroundColor: const Color.fromARGB(88, 167, 158, 158),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const CustomLoading();
                  } else if (state is BookingAcceptedLoaded) {
                    final bookings = state.acceptedBookings;

                    _filteredBookings = bookings.where((booking) {
                      final query = _searchController.text.toLowerCase();
                      final fullnameMatch = booking.user?.fullname
                              .toLowerCase()
                              .contains(query) ??
                          false;
                      final vehicleTypeMatch =
                          booking.vehicleType.toLowerCase().contains(query);
                      return fullnameMatch || vehicleTypeMatch;
                    }).toList();

                    _filteredBookings = _filteredBookings.reversed.toList();

                    if (_filteredBookings.isEmpty) {
                      return const Center(
                        child: Text(
                          'No bookings yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: _filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = _filteredBookings[index];

                        return GestureDetector(
                          onTap: () {
                            _showBookingDetailsBottomSheet(context, booking);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '   Booked By: ${booking.user?.fullname}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      _statusBadge(booking.status),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '   Vehicle Type: ${booking.vehicleType}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(255, 94, 86, 86)),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          final bloc =
                                              BlocProvider.of<BookingBloc>(
                                                  context);
                                          bloc.add(
                                              CompletedBooking(booking.id!));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          minimumSize: const Size(140, 43),
                                        ),
                                        icon: const Icon(Icons.check,
                                            color: Colors.white),
                                        label: const Text('Finish Service!',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is RequestError) {
                    return Center(child: Text(state.error));
                  } else {
                    return const Center(child: Text(''));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color badgeColor;

    switch (status) {
      default:
        badgeColor = Colors.green;
    }

    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: badgeColor, borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.center,
      child: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _showBookingDetailsBottomSheet(BuildContext context, Booking booking) {
    final serviceTypeString = booking.serviceType.join(', ');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.red),
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Booked By: ${booking.user?.fullname}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.build, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Service Type: $serviceTypeString',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Vehicle: ${booking.vehicleType}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Time: ${booking.time}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Date: ${DateFormat('MM/dd/yyyy').format(booking.date)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Status: ${booking.status}',
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: booking.status == 'Approved'
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
