import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/saved_movie_model.dart';

abstract class WatchlistRemoteDataSource {
  Future<List<SavedMovieModel>> getWatchlist();
  Future<void> addToWatchlist(SavedMovieModel movie);
  Future<void> removeFromWatchlist(int movieId);
  Future<bool> isInWatchlist(int movieId);
}

class WatchlistRemoteDataSourceImpl implements WatchlistRemoteDataSource {
  final FirebaseFirestore firestore;
  final String? Function() getUserId;

  WatchlistRemoteDataSourceImpl({
    required this.firestore,
    required this.getUserId,
  });

  CollectionReference<Map<String, dynamic>> get _collection {
    final uid = getUserId();
    if (uid == null || uid.isEmpty) {
      throw const AuthException(message: 'User not logged in');
    }
    return firestore.collection('users').doc(uid).collection('watchlist');
  }

  @override
  Future<List<SavedMovieModel>> getWatchlist() async {
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
  Future<void> addToWatchlist(SavedMovieModel movie) async {
    try {
      await _collection.doc(movie.movieId.toString()).set(movie.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> removeFromWatchlist(int movieId) async {
    try {
      await _collection.doc(movieId.toString()).delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }

  @override
  Future<bool> isInWatchlist(int movieId) async {
    try {
      final doc = await _collection.doc(movieId.toString()).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firestore error');
    }
  }
}