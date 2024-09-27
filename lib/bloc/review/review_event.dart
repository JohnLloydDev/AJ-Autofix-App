import 'package:equatable/equatable.dart';
import 'package:aj_autofix/models/review_model.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchReviews extends ReviewEvent {}

class CreateReview extends ReviewEvent {
  final Review review;

  const CreateReview(this.review);

  @override
  List<Object?> get props => [review];
}
