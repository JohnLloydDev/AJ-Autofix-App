import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String? id;
  final User? user;
  final int rating;
  final String content;

  const Review({
    this.id,
    this.user,
    required this.rating,
    required this.content,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      user: json['userId'] != null && json['userId'] is Map<String, dynamic>
          ? User.fromJson(json['userId'])
          : null,
      rating: json['rating'] ?? 0,
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user?.id,
      'rating': rating,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [id, user, rating, content];
}
