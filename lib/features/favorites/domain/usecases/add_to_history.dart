import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_movie_entity.dart';
import '../repositories/history_repository.dart';

class AddToHistory implements UseCase<Unit, SavedMovieEntity> {
  final HistoryRepository repository;

  AddToHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedMovieEntity movie) {
    return repository.addToHistory(movie);
  }
}