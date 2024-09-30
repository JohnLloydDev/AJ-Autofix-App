
import 'package:aj_autofix/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<Review>> getAllReviews();
  
  Future<Map<String, dynamic>> createReviews(Review review);
}
