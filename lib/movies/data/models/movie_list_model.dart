import 'package:movies_app/movies/data/models/movie_model.dart';

class MovieListModel {
  String? status;
  String? statusMessage;
  MovieListDataModel? data;

  MovieListModel({this.status, this.statusMessage, this.data});

  MovieListModel.fromJson(Map<String, dynamic> json) {
    status = json["status"] as String?;
    statusMessage = json["status_message"] as String?;
    data =
        json["data"] == null
            ? null
            : MovieListDataModel.fromJson(json["data"] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["status"] = status;
    map["status_message"] = statusMessage;
    if (data != null) {
      map["data"] = data?.toJson();
    }
    return map;
  }
}

class MovieListDataModel {
  int? movieCount;
  int? limit;
  int? pageNumber;
  List<MovieModel>? movies;

  MovieListDataModel({
    this.movieCount,
    this.limit,
    this.pageNumber,
    this.movies,
  });

  MovieListDataModel.fromJson(Map<String, dynamic> json) {
    movieCount = (json["movie_count"] as num?)?.toInt();
    limit = (json["limit"] as num?)?.toInt();
    pageNumber = (json["page_number"] as num?)?.toInt();
    movies =
        (json["movies"] as List?)
            ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["movie_count"] = movieCount;
    map["limit"] = limit;
    map["page_number"] = pageNumber;
    if (movies != null) {
      map["movies"] = movies?.map((e) => e.toJson()).toList();
    }
    return map;
  }
}
