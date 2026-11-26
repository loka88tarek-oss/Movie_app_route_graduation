import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlist implements UseCase<Unit, int> {
  final WatchlistRepository repository;

  RemoveFromWatchlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int movieId) {
    return repository.removeFromWatchlist(movieId);
  }
}