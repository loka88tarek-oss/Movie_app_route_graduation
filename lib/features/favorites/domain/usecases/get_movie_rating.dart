
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_rating_entity.dart';
import '../repositories/rating_repository.dart';

class GetMovieRating implements UseCase<MovieRatingEntity?, int> {
  final RatingRepository repository;

  GetMovieRating(this.repository);

  @override
  Future<Either<Failure, MovieRatingEntity?>> call(int movieId) {
    return repository.getRating(movieId);
  }
}