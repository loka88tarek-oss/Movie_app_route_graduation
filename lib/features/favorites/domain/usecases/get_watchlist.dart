import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_movie_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlist implements UseCase<List<SavedMovieEntity>, NoParams> {
  final WatchlistRepository repository;

  GetWatchlist(this.repository);

  @override
  Future<Either<Failure, List<SavedMovieEntity>>> call(NoParams params) {
    return repository.getWatchlist();
  }
}