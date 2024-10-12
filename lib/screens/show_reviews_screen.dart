import 'package:aj_autofix/bloc/review/review_bloc.dart';
import 'package:aj_autofix/bloc/review/review_event.dart';
import 'package:aj_autofix/bloc/review/review_state.dart';
import 'package:aj_autofix/screens/review.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowReviewsScreen extends StatefulWidget {
  const ShowReviewsScreen({super.key});

  @override
  State<ShowReviewsScreen> createState() => _ShowReviewsScreenState();
}

class _ShowReviewsScreenState extends State<ShowReviewsScreen> {
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
          decoration: kAppBarGradient,
        ),
        title: const Text('Reviews'),
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
                  final review = state.reviews.reversed.toList()[index];
                  return ReviewCard(review: review);
                },
              );
            }
            return const Center(child: Text('No reviews yet.'));
          },
        ),
      ),
    );
  }
}
