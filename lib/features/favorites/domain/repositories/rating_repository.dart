import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_rating_entity.dart';

abstract class RatingRepository {
  Future<Either<Failure, MovieRatingEntity?>> getRating(int movieId);
  Future<Either<Failure, Unit>> rateMovie(MovieRatingEntity rating);
  Future<Either<Failure, Unit>> deleteRating(int movieId);
}