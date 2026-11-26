import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_movie_entity.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<SavedMovieEntity>>> getHistory();
  Future<Either<Failure, Unit>> addToHistory(SavedMovieEntity movie);
  Future<Either<Failure, Unit>> clearHistory();
}