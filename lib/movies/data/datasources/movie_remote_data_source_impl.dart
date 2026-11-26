import 'package:dio/dio.dart';
import 'package:movies_app/core/constants/api_constants.dart';

import 'package:movies_app/movies/data/datasources/movie_remote_data_source.dart';
import 'package:movies_app/movies/data/models/movie_details_model.dart';
import 'package:movies_app/movies/data/models/movie_list_model.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl(this.dio);

  @override
  Future<MovieListModel> getMovies({
    required int page,
    required int limit,
    String? genre,
    String? sortBy,
  }) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.listMovies}',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (genre != null) 'genre': genre,
        if (sortBy != null) 'sort_by': sortBy,
      },
    );
    return MovieListModel.fromJson(response.data);
  }

  @override
  @override
  Future<MovieDetailsModel> getMovieDetails({required int id}) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.movieDetails}',
      queryParameters: {'movie_id': id, 'with_images': true, 'with_cast': true},
    );
    return MovieDetailsModel.fromJson(response.data['data']['movie']);
  }

  @override
  Future<MovieListModel> getSimilarMovies({required int id}) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.movieSuggestions}',
      queryParameters: {'movie_id': id},
    );
    return MovieListModel.fromJson(response.data);
  }

  @override
  Future<MovieListModel> searchMovies({
    required int page,
    required int limit,
    required String query,
  }) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.listMovies}',
      queryParameters: {'page': page, 'limit': limit, 'query_term': query},
    );
    return MovieListModel.fromJson(response.data);
  }
}
