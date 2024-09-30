import 'package:aj_autofix/models/review_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/repositories/review_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc(this.reviewRepository) : super(ReviewInitial()) {
    on<FetchReviews>(_onFetchReviews);
    on<CreateReview>(_onCreateReview);
  }

  Future<void> _onFetchReviews(
      FetchReviews event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoading());
      final reviews = await reviewRepository.getAllReviews();
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onCreateReview(
      CreateReview event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoading());
      final response = await reviewRepository.createReviews(event.review);
      if (response.containsKey('review') &&
          response['review'] is Map<String, dynamic>) {
        final Map<String, dynamic> reviewData = response['review'];
        final review = Review.fromJson(reviewData);
        final bool isUpdate = response['isUpdate'] as bool;
        emit(ReviewCreated(review: review, isUpdate: isUpdate));
        add(FetchReviews());
      } else {
        throw Exception(
            "Invalid response format: 'review' key not found or incorrect type");
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
