import 'dart:io';
import 'package:aj_autofix/utils/constants.dart';
import 'package:aj_autofix/utils/custom_loading.dart';
import 'package:aj_autofix/utils/profile_picture_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:aj_autofix/bloc/review/review_state.dart';
import 'package:aj_autofix/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(FetchReviews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kAppBar,
        ),
        title: const Text('Reviews'),
        centerTitle: true,
      ),
      body: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
              ),
            );
          } else if (state is ReviewCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Review ${state.isUpdate ? "updated" : "created"} successfully!'),
              ),
            );
          }
        },
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const CustomLoading();
            } else if (state is ReviewLoaded) {
              return ListView.builder(
                itemCount: state.reviews.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final review = state.reviews[index];
                  return ReviewCard(review: review);
                },
              );
            }
            return const Center(child: Text('No reviews found.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? content;
    int? rating;

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
                  const Text(
                    'Submit a Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rate the service',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Rating',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(5, (index) => index + 1)
                        .map((rating) => DropdownMenuItem(
                              value: rating,
                              child: Text(rating.toString()),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a rating';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      rating = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Review',
                      border: OutlineInputBorder(),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final newReview = Review(
                            rating: rating!,
                            content: content!,
                          );

                          context
                              .read<ReviewBloc>()
                              .add(CreateReview(newReview));

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // ignore: use_build_context_synchronously
      context.read<ReviewBloc>().add(FetchReviews());
    });
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: _getProfileImage(
                    review.user?.profilePicture,
                    review.user?.fullname ?? '',
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user?.fullname ?? "Anonymous",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RatingBar.builder(
                      itemSize: 20,
                      ignoreGestures: true,
                      initialRating: review.rating.toDouble(),
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              review.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _getProfileImage(String? profilePicture, String fullname) {
  if (profilePicture == null || profilePicture.isEmpty) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: getRandomBackgroundColor(fullname),
      child: Text(
        fullname.isNotEmpty ? fullname[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  if (profilePicture.startsWith('http') || profilePicture.startsWith('https')) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(profilePicture),
      child: null,
    );
  }

  try {
    final file = File(profilePicture);
    if (file.existsSync()) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(file),
        child: null,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return CircleAvatar(
    radius: 30,
    backgroundColor: getRandomBackgroundColor(fullname),
    child: Text(
      fullname.isNotEmpty ? fullname[0].toUpperCase() : 'U',
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
