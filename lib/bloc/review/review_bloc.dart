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

     await reviewRepository.createReviews(event.review);
     emit(ReviewCreated());
      add(FetchReviews());
    
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
