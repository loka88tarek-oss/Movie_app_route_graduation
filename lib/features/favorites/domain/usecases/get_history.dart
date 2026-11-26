import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/saved_movie_entity.dart';
import '../repositories/history_repository.dart';

class GetHistory implements UseCase<List<SavedMovieEntity>, NoParams> {
  final HistoryRepository repository;

  GetHistory(this.repository);

  @override
  Future<Either<Failure, List<SavedMovieEntity>>> call(NoParams params) {
    return repository.getHistory();
  }
}