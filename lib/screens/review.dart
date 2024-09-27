import 'package:aj_autofix/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:aj_autofix/bloc/review/review_state.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all reviews when the screen is built
    context.read<ReviewBloc>().add(FetchReviews());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
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
          } else if (state is ReviewError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No reviews found.'));
        },
      ),
    );
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
              'Name: ${review.user?.fullname}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating: ${review.rating}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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



//   void _showReviewDialog(BuildContext context) {
//     double rating = 0;
//     TextEditingController reviewController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(20),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Rate the service',
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return IconButton(
//                     icon: Icon(
//                       index < rating ? Icons.star : Icons.star_border,
//                       color: Colors.amber,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       rating = (index + 1).toDouble();
//                     },
//                   );
//                 }),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: reviewController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Write your review',
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (reviewController.text.isNotEmpty && rating > 0) {
//                     final review = Review(
//                       name: 'New User',  // Replace with actual user
//                       rating: rating,
//                       review: reviewController.text, content: '',
//                     );
//                     BlocProvider.of<ReviewBloc>(context).add(PostReview(review));
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

