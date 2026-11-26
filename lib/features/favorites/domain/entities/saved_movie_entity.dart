import 'package:equatable/equatable.dart';

class SavedMovieEntity extends Equatable {
  final int movieId;
  final String title;
  final String posterPath;
  final double rating;
  final DateTime savedAt;

  const SavedMovieEntity({
    required this.movieId,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.savedAt,
  });

  @override
  List<Object?> get props => [movieId, title, posterPath, rating, savedAt];
}