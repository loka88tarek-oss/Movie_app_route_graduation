import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_rating_entity.dart';
import '../repositories/rating_repository.dart';

class RateMovie implements UseCase<Unit, MovieRatingEntity> {
  final RatingRepository repository;

  RateMovie(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MovieRatingEntity rating) {
    return repository.rateMovie(rating);
  }
}