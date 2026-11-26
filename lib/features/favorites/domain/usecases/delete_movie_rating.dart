import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/rating_repository.dart';

class DeleteMovieRating implements UseCase<Unit, int> {
  final RatingRepository repository;

  DeleteMovieRating(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int movieId) {
    return repository.deleteRating(movieId);
  }
}