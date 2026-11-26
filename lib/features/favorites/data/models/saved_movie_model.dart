
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/saved_movie_entity.dart';

class SavedMovieModel extends SavedMovieEntity {
  const SavedMovieModel({
    required super.movieId,
    required super.title,
    required super.posterPath,
    required super.rating,
    required super.savedAt,
  });

  factory SavedMovieModel.fromEntity(SavedMovieEntity entity) {
    return SavedMovieModel(
      movieId: entity.movieId,
      title: entity.title,
      posterPath: entity.posterPath,
      rating: entity.rating,
      savedAt: entity.savedAt,
    );
  }

  factory SavedMovieModel.fromMap(Map<String, dynamic> map) {
    return SavedMovieModel(
      movieId: map['movieId'] as int,
      title: map['title'] as String,
      posterPath: map['posterPath'] as String,
      rating: (map['rating'] as num).toDouble(),
      savedAt: (map['savedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
      'savedAt': Timestamp.fromDate(savedAt),
    };
  }
}