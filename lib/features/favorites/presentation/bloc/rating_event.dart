import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_rating_entity.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieRating extends RatingEvent {
  final int movieId;

  const LoadMovieRating(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class SubmitMovieRating extends RatingEvent {
  final MovieRatingEntity rating;

  const SubmitMovieRating(this.rating);

  @override
  List<Object?> get props => [rating];
}

class RemoveMovieRating extends RatingEvent {
  final int movieId;

  const RemoveMovieRating(this.movieId);

  @override
  List<Object?> get props => [movieId];
}