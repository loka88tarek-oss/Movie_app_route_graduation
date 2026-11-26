import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/movie_rating_model.dart';

abstract class RatingRemoteDataSource {
  Future<MovieRatingModel?> getRating(int movieId);
  Future<void> rateMovie(MovieRatingModel rating);
  Future<void> deleteRating(int movieId);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  final FirebaseFirestore firestore;
  final String? Function() getUserId;

  RatingRemoteDataSourceImpl({
    required this.firestore,
    required this.getUserId,
  });

  CollectionReference<Map<String, dynamic>> get _collection {
    final uid = getUserId();
    if (uid == null || uid.isEmpty) {
      throw const AuthException(message: 'User not logged in');
    }
    return firestore.collection('users').doc(uid).collection('ratings');
  }

  @override
  Future<MovieRatingModel?> getRating(int movieId) async {
    try {
      final doc = await _collection.doc(movieId.toString()).get();
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return MovieRatingModel.fromMap(data);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> rateMovie(MovieRatingModel rating) async {
    try {
      await _collection.doc(rating.movieId.toString()).set(rating.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> deleteRating(int movieId) async {
    try {
      await _collection.doc(movieId.toString()).delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }
}