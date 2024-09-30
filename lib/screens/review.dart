import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:aj_autofix/bloc/review/review_state.dart';
import 'package:aj_autofix/models/review_model.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all reviews when the screen is first loaded
    context.read<ReviewBloc>().add(FetchReviews());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
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
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewLoaded) {
              return ListView.builder(
                itemCount: state.reviews.length,
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
        child: const Icon(Icons.add),
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rate the service',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Put your rate',
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
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Write your review',
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          // Create the new review
                          final newReview = Review(
                            rating: rating!,
                            content: content!,
                          );

                          // Add the review to the bloc
                          context
                              .read<ReviewBloc>()
                              .add(CreateReview(newReview));

                          // Close the dialog
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // This will be executed after the dialog is closed
      // Fetch reviews again to update the ReviewScreen
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.user?.fullname ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating: ${review.rating}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              review.content,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
