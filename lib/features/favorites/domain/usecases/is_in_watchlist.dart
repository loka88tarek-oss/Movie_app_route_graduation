import 'package:dartz/dartz.dart';
import 'package:movies_app/core/errors/failures.dart';
import 'package:movies_app/core/usecases/usecase.dart';
import 'package:movies_app/features/favorites/domain/repositories/watchlist_repository.dart';

class IsInWatchlist  implements UseCase<bool,int>{
  final WatchlistRepository repository;

  IsInWatchlist(this.repository);
  @override
  Future<Either<Failure, bool>> call(int movieId) {
    return repository.isInWatchlist(movieId);
  }
}