import 'package:movies_app/movies/domain/entities/movie_entity.dart';

class MovieModel {
  int? id;
  String? url;
  String? imdbCode;
  String? title;
  String? titleEnglish;
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<String>? genres;
  String? summary;
  String? descriptionFull;
  String? synopsis;
  String? ytTrailerCode;
  String? language;
  String? mpaRating;
  String? backgroundImage;
  String? backgroundImageOriginal;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  String? state;
  String? dateUploaded;
  int? dateUploadedUnix;

  MovieModel({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.state,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  MovieModel.fromJson(Map<String, dynamic> json) {
    id = (json["id"] as num?)?.toInt();
    url = json["url"];
    imdbCode = json["imdb_code"];
    title = json["title"];
    titleEnglish = json["title_english"];
    titleLong = json["title_long"];
    slug = json["slug"];
    year = (json["year"] as num?)?.toInt();
    rating = (json["rating"] as num?)?.toDouble();
    runtime = (json["runtime"] as num?)?.toInt();
    genres = json["genres"] == null ? null : List<String>.from(json["genres"]);
    summary = json["summary"];
    descriptionFull = json["description_full"];
    synopsis = json["synopsis"];
    ytTrailerCode = json["yt_trailer_code"];
    language = json["language"];
    mpaRating = json["mpa_rating"];
    backgroundImage = json["background_image"];
    backgroundImageOriginal = json["background_image_original"];
    smallCoverImage = json["small_cover_image"];
    mediumCoverImage = json["medium_cover_image"];
    largeCoverImage = json["large_cover_image"];
    state = json["state"];
    dateUploaded = json["date_uploaded"];
    dateUploadedUnix = (json["date_uploaded_unix"] as num?)?.toInt();
  }

  static List<MovieModel> fromList(List<dynamic> list) {
    return list
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["url"] = url;
    data["imdb_code"] = imdbCode;
    data["title"] = title;
    data["title_english"] = titleEnglish;
    data["title_long"] = titleLong;
    data["slug"] = slug;
    data["year"] = year;
    data["rating"] = rating;
    data["runtime"] = runtime;
    if (genres != null) {
      data["genres"] = genres;
    }
    data["summary"] = summary;
    data["description_full"] = descriptionFull;
    data["synopsis"] = synopsis;
    data["yt_trailer_code"] = ytTrailerCode;
    data["language"] = language;
    data["mpa_rating"] = mpaRating;
    data["background_image"] = backgroundImage;
    data["background_image_original"] = backgroundImageOriginal;
    data["small_cover_image"] = smallCoverImage;
    data["medium_cover_image"] = mediumCoverImage;
    data["large_cover_image"] = largeCoverImage;
    data["state"] = state;
    data["date_uploaded"] = dateUploaded;
    data["date_uploaded_unix"] = dateUploadedUnix;
    return data;
  }

  MovieEntity toEntity() {
    return MovieEntity(
      id: id ?? 0,
      title: title ?? '',
      year: year ?? 0,
      rating: rating ?? 0.0,
      runtime: runtime ?? 0,
      genres: genres ?? [],
      summary: summary ?? '',
      ytTrailerCode: ytTrailerCode ?? '',
      language: language ?? '',
      backgroundImage: backgroundImage ?? '',
      mediumCoverImage: mediumCoverImage ?? '',
      largeCoverImage: largeCoverImage ?? '',
    );
  }
}
