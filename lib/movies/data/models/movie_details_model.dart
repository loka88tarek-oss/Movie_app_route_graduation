import 'package:movies_app/movies/data/models/cast_model.dart';

import '../../domain/entities/movie_entity.dart';

class MovieDetailsModel {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final List<String> genres;
  final String summary;
  final String ytTrailerCode;
  final String language;
  final String backgroundImage;
  final String mediumCoverImage;
  final String largeCoverImage;
  final List<String> screenshots;
  final List<CastModel> cast;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.genres,
    required this.summary,
    required this.ytTrailerCode,
    required this.language,
    required this.backgroundImage,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.screenshots,
    required this.cast,
  });

  /// [json] is the movie object itself (data['movie']).
  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    // Screenshots come as 3 separate keys; keep only the non-empty ones.
    final screenshots = <String>[
      for (final key in [
        'large_screenshot_image1',
        'large_screenshot_image2',
        'large_screenshot_image3',
      ])
        if ((json[key] as String?)?.isNotEmpty ?? false) json[key] as String,
    ];

    // Summary: details endpoint uses description_full, list uses summary.
    final summary = _firstNonEmpty([
      json['description_full'] as String?,
      json['summary'] as String?,
      json['description_intro'] as String?,
    ]);

    final castJson = json['cast'] as List<dynamic>? ?? const [];

    return MovieDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      runtime: json['runtime'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      genres:
          (json['genres'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
      summary: summary,
      ytTrailerCode: json['yt_trailer_code'] as String? ?? '',
      language: json['language'] as String? ?? '',
      backgroundImage: json['background_image'] as String? ?? '',
      mediumCoverImage: json['medium_cover_image'] as String? ?? '',
      largeCoverImage: json['large_cover_image'] as String? ?? '',
      screenshots: screenshots,
      cast:
          castJson
              .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  MovieDetailsEntity toEntity() => MovieDetailsEntity(
    id: id,
    title: title,
    year: year,
    rating: rating,
    runtime: runtime,
    likeCount: likeCount,
    genres: genres,
    summary: summary,
    ytTrailerCode: ytTrailerCode,
    language: language,
    backgroundImage: backgroundImage,
    mediumCoverImage: mediumCoverImage,
    largeCoverImage: largeCoverImage,
    screenshots: screenshots,
    cast: cast.map((c) => c.toEntity()).toList(),
  );

  static String _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.isNotEmpty) return v;
    }
    return '';
  }
}
