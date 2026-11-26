import 'package:equatable/equatable.dart';

class MovieRatingEntity extends Equatable {
  final int movieId;
  final int rating;
  final String review;
  final DateTime ratedAt;

  const MovieRatingEntity({
    required this.movieId,
    required this.rating,
    this.review = '',
    required this.ratedAt,
  });

  @override
  List<Object?> get props => [movieId, rating, review, ratedAt];
}