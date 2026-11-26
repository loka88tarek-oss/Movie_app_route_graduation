import 'package:movies_app/movies/data/datasources/movie_local_data_source.dart';
import 'package:movies_app/movies/data/datasources/movie_remote_data_source.dart';
import 'package:movies_app/movies/data/models/movie_list_model.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/domain/repo/movie_repo_abstract.dart';

class MovieRepoImplement implements MovieRepoAbstract {
  MovieRepoImplement(this.remoteDataSource, this.localDataSource);

  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  List<MovieEntity> _toEntities(MovieListModel response) {
    return response.data?.movies?.map((m) => m.toEntity()).toList() ?? [];
  }

  @override
  Future<List<MovieEntity>> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? sortBy,
  }) async {
    final key = 'movies_p${page}_l${limit}_g${genre ?? 'all'}_s${sortBy ?? 'default'}';

    final MovieListModel response;
    try {
      response = await remoteDataSource.getMovies(
        page: page,
        limit: limit,
        genre: genre,
        sortBy: sortBy,
      );
    } catch (_) {
      final cached = localDataSource.getMovieList(key);
      if (cached == null) rethrow;
      return _toEntities(cached);
    }

    await localDataSource.saveMovieList(key, response);
    return _toEntities(response);
  }

  @override
  Future<MovieDetailsEntity> getMovieDetails({required int id}) async {
    final response = await remoteDataSource.getMovieDetails(id: id);
    return response.toEntity();
  }

  @override
  Future<List<MovieEntity>> getSimilarMovies({required int id}) async {
    final response = await remoteDataSource.getSimilarMovies(id: id);
    return _toEntities(response);
  }

  @override
  Future<List<MovieEntity>> searchMovies({
    required int page,
    required int limit,
    required String query,
  }) async {
    final response = await remoteDataSource.searchMovies(
      page: page,
      limit: limit,
      query: query,
    );
    return _toEntities(response);
  }
}