import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/movie_rating_entity.dart';

class MovieRatingModel extends MovieRatingEntity {
  const MovieRatingModel({
    required super.movieId,
    required super.rating,
    super.review,
    required super.ratedAt,
  });

  factory MovieRatingModel.fromEntity(MovieRatingEntity entity) {
    return MovieRatingModel(
      movieId: entity.movieId,
      rating: entity.rating,
      review: entity.review,
      ratedAt: entity.ratedAt,
    );
  }

  factory MovieRatingModel.fromMap(Map<String, dynamic> map) {
    return MovieRatingModel(
      movieId: map['movieId'] as int,
      rating: (map['rating'] as num).toInt(),
      review: (map['review'] as String?) ?? '',
      ratedAt: (map['ratedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'rating': rating,
      'review': review,
      'ratedAt': Timestamp.fromDate(ratedAt),
    };
  }
}