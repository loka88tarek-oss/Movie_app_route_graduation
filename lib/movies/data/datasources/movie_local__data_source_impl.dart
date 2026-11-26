import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:movies_app/movies/data/datasources/movie_local_data_source.dart';
import 'package:movies_app/movies/data/models/movie_list_model.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl(this.box);

  final Box<String> box;

  @override
  Future<void> saveMovieList(String key, MovieListModel model) async {
    await box.put(key, jsonEncode(model.toJson()));
  }

  @override
  MovieListModel? getMovieList(String key) {
    final cached = box.get(key);
    if (cached == null) return null;
    try {
      return MovieListModel.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}