import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/history_repository.dart';

class ClearHistory implements UseCase<Unit, NoParams> {
  final HistoryRepository repository;

  ClearHistory(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.clearHistory();
  }
}