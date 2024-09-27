import 'package:aj_autofix/models/user_model.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String? id;
  final User? user;
  final String fullname;
  final int rating;
  final String content;

  const Review({
    this.id,
    this.user,
    required this.fullname,
    required this.rating,
    required this.content,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null, 
      fullname: json['fullname'] ?? '', 
      rating: json['rating'] ?? 0, 
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user?.toJson(),
      'fullname': fullname,  
      'rating': rating,
      'content': content,
    };
  }

  @override
  List<Object?> get props => [id, user, fullname, rating, content];
}
