import 'package:movies_app/movies/data/models/movie_list_model.dart';

abstract class MovieLocalDataSource {
  Future<void> saveMovieList(String key, MovieListModel model);

  MovieListModel? getMovieList(String key);
}