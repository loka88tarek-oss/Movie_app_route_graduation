import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final List<String> genres;
  final String summary;
  final String ytTrailerCode;
  final String language;
  final String backgroundImage;
  final String mediumCoverImage;
  final String largeCoverImage;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.summary,
    required this.ytTrailerCode,
    required this.language,
    required this.backgroundImage,
    required this.mediumCoverImage,
    required this.largeCoverImage,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    year,
    rating,
    runtime,
    genres,
    summary,
    ytTrailerCode,
    language,
    backgroundImage,
    mediumCoverImage,
    largeCoverImage,
  ];
}

class MovieDetailsEntity extends Equatable {
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
  final List<CastEntity> cast;

  const MovieDetailsEntity({
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

  @override
  List<Object?> get props => [
    id,
    title,
    year,
    rating,
    runtime,
    likeCount,
    genres,
    summary,
    ytTrailerCode,
    language,
    backgroundImage,
    mediumCoverImage,
    largeCoverImage,
    screenshots,
    cast,
  ];
}

class CastEntity extends Equatable {
  final String name;
  final String characterName;
  final String? imageUrl;

  const CastEntity({
    required this.name,
    required this.characterName,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, characterName, imageUrl];
}
