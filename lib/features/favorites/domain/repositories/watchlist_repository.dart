import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_movie_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<SavedMovieEntity>>> getWatchlist();
  Future<Either<Failure, Unit>> addToWatchlist(SavedMovieEntity movie);
  Future<Either<Failure, Unit>> removeFromWatchlist(int movieId);
  Future<Either<Failure, bool>> isInWatchlist(int movieId);
}