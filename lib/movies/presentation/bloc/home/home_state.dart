import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_entity.dart';

class GenreSectionState extends Equatable {
  final String genre;
  final bool isLoading;
  final List<MovieEntity> movies;
  final String error;

  const GenreSectionState({
    required this.genre,
    this.isLoading = true,
    this.movies = const [],
    this.error = '',
  });

  GenreSectionState copyWith({
    bool? isLoading,
    List<MovieEntity>? movies,
    String? error,
  }) {
    return GenreSectionState(
      genre: genre,
      isLoading: isLoading ?? this.isLoading,
      movies: movies ?? this.movies,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [genre, isLoading, movies, error];
}

class HomeState extends Equatable {
  final bool isCarouselLoading;
  final List<MovieEntity> carouselMovies;
  final String carouselError;

  final List<GenreSectionState> sections;

  const HomeState({
    this.isCarouselLoading = true,
    this.carouselMovies = const [],
    this.carouselError = '',
    this.sections = const [],
  });

  HomeState copyWith({
    bool? isCarouselLoading,
    List<MovieEntity>? carouselMovies,
    String? carouselError,
    List<GenreSectionState>? sections,
  }) {
    return HomeState(
      isCarouselLoading: isCarouselLoading ?? this.isCarouselLoading,
      carouselMovies: carouselMovies ?? this.carouselMovies,
      carouselError: carouselError ?? this.carouselError,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [
    isCarouselLoading,
    carouselMovies,
    carouselError,
    sections,
  ];
}
