import 'package:equatable/equatable.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';

abstract class BrowseState extends Equatable {
  const BrowseState();

  @override
  List<Object?> get props => [];
}

class BrowseInitial extends BrowseState {
  const BrowseInitial();
}

class BrowseLoading extends BrowseState {
  const BrowseLoading();
}

class BrowseLoaded extends BrowseState {
  final List<MovieEntity> movies;
  final String? selectedGenre;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const BrowseLoaded({
    required this.movies,
    this.selectedGenre,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  BrowseLoaded copyWith({
    List<MovieEntity>? movies,
    String? selectedGenre,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return BrowseLoaded(
      movies: movies ?? this.movies,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    movies,
    selectedGenre,
    hasReachedMax,
    isLoadingMore,
  ];
}

class BrowseError extends BrowseState {
  final String message;

  const BrowseError(this.message);

  @override
  List<Object?> get props => [message];
}
