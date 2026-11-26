import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_rating_entity.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {
  const RatingInitial();
}

class RatingLoading extends RatingState {
  final int movieId;

  const RatingLoading(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

/// الـ submit أو الـ remove شغالين دلوقتي (علشان نوقف الزرار ونعرض loader).
/// [rating] هو التقييم القديم لحد ما العملية تخلص.
class RatingSubmitting extends RatingState {
  final int movieId;
  final MovieRatingEntity? rating;

  const RatingSubmitting(this.movieId, this.rating);

  @override
  List<Object?> get props => [movieId, rating];
}

class RatingLoaded extends RatingState {
  final int movieId;
  final MovieRatingEntity? rating;

  const RatingLoaded(this.movieId, this.rating);

  @override
  List<Object?> get props => [movieId, rating];
}

/// [movieId] و [rating] اختياريين: لو اتبعتوا، الـ UI يفضل يعرض آخر تقييم
/// معروف بدل ما يرجع كأن مفيش تقييم.
class RatingError extends RatingState {
  final String message;
  final int? movieId;
  final MovieRatingEntity? rating;

  const RatingError(this.message, {this.movieId, this.rating});

  @override
  List<Object?> get props => [message, movieId, rating];
}