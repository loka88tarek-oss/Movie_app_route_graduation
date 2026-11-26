import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_movie_entity.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlist implements UseCase<Unit, SavedMovieEntity> {
  final WatchlistRepository repository;

  AddToWatchlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SavedMovieEntity movie) {
    return repository.addToWatchlist(movie);
  }
}