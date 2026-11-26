import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/saved_movie_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_remote_datasource.dart';
import '../models/saved_movie_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistRemoteDataSource remoteDataSource;

  WatchlistRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<SavedMovieEntity>>> getWatchlist() async {
    try {
      final movies = await remoteDataSource.getWatchlist();
      return Right(movies);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addToWatchlist(SavedMovieEntity movie) async {
    try {
      await remoteDataSource.addToWatchlist(SavedMovieModel.fromEntity(movie));
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWatchlist(int movieId) async {
    try {
      await remoteDataSource.removeFromWatchlist(movieId);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isInWatchlist(int movieId) async {
    try {
      final result = await remoteDataSource.isInWatchlist(movieId);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}