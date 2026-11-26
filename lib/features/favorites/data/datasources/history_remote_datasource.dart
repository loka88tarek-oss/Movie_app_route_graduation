import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/saved_movie_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<SavedMovieModel>> getHistory();
  Future<void> addToHistory(SavedMovieModel movie);
  Future<void> clearHistory();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore firestore;
  final String? Function() getUserId;

  HistoryRemoteDataSourceImpl({
    required this.firestore,
    required this.getUserId,
  });

  CollectionReference<Map<String, dynamic>> get _collection {
    final uid = getUserId();
    if (uid == null || uid.isEmpty) {
      throw const AuthException(message: 'User not logged in');
    }
    return firestore.collection('users').doc(uid).collection('history');
  }

  @override
  Future<List<SavedMovieModel>> getHistory() async {
    try {
      final snapshot =
          await _collection.orderBy('savedAt', descending: true).get();
      return snapshot.docs
          .map((doc) => SavedMovieModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> addToHistory(SavedMovieModel movie) async {
    try {
      await _collection.doc(movie.movieId.toString()).set(movie.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      final snapshot = await _collection.get();
      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }
}