import 'package:aj_autofix/bloc/booking/booking_bloc.dart';
import 'package:aj_autofix/bloc/booking/booking_event.dart';
import 'package:aj_autofix/bloc/booking/booking_state.dart';
import 'package:aj_autofix/models/review_model.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:aj_autofix/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UserPendingRequest extends StatefulWidget {
  const UserPendingRequest({super.key});

  @override
  State<UserPendingRequest> createState() => _UserPendingRequestState();
}

class _UserPendingRequestState extends State<UserPendingRequest> {
  @override
  void initState() {
    super.initState();
    _fetchUserBookings();
  }

  Future<void> _fetchUserBookings() async {
    BlocProvider.of<BookingBloc>(context).add(GetUserBooking());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text(
          'Pending Requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const CustomLoading();
          } else if (state is BookingUserLoaded) {
            final bookings = state.userBookings;

            if (bookings.isEmpty) {
              return const Center(
                child: Text(''),
              );
            }

            return RefreshIndicator(
              onRefresh: _fetchUserBookings,
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings.reversed.toList()[index];
                  return TaskCard(
                    title: booking.user?.fullname ?? 'Unknown User',
                    subtitle: booking.serviceType.join(', '),
                    status: booking.status,
                    date: DateFormat('MM/dd/yyyy').format(booking.date),
                    time: booking.time.toString(),
                    carname: booking.vehicleType,
                    statusColor: _getStatusColor(booking.status),
                    onReviewPressed: () {
                      if (booking.status == 'Completed') {
                        _showAddReviewDialog(context);
                      }
                    },
                  );
                },
              ),
            );
          } else if (state is RequestError) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            return const CustomLoading();
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showAddReviewDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? content;
    double? rating;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rate the Service',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 30.0, 
                        height: 30.0, 
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.black),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: const Color.fromARGB(255, 255, 255, 255),
                          iconSize:
                              12.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RatingBar(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: const Icon(Icons.star, color: Colors.amber),
                      half: const Icon(Icons.star_half, color: Colors.amber),
                      empty: const Icon(Icons.star_border, color: Colors.amber),
                    ),
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Write your review',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    maxLines: 5,
                    maxLength: 300,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Share your experience...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter review content';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      content = value;
                    },
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E88A1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final newReview = Review(
                            rating: rating!.toDouble().toInt(),
                            content: content!,
                          );

                          context
                              .read<ReviewBloc>()
                              .add(CreateReview(newReview));

                          Fluttertoast.showToast(
                            msg: "Your review has been posted!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
