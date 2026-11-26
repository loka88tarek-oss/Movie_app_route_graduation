import 'package:movies_app/movies/data/models/movie_details_model.dart';
import 'package:movies_app/movies/data/models/movie_list_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieListModel> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? sortBy,
  });

  Future<MovieListModel> searchMovies({
    required int page,
    required int limit,
    required String query,
  });

  Future<MovieDetailsModel> getMovieDetails({required int id});

  Future<MovieListModel> getSimilarMovies({required int id});
}
