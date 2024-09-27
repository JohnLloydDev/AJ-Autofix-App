
import 'package:aj_autofix/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<Review>> getAllReviews();
  
  Future<void> createReviews(Review review);
}
