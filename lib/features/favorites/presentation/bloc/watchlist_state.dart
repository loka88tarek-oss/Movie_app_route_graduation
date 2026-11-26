import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_movie_entity.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  /// آخر قائمة معروفة. الـ states اللي معاها قائمة بتعمل override للـ getter ده.
  List<SavedMovieEntity> get movies => const [];

  bool isSaved(int movieId) => movies.any((m) => m.movieId == movieId);

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistLoaded extends WatchlistState {
  @override
  final List<SavedMovieEntity> movies;

  const WatchlistLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// بيحتفظ بآخر قائمة معروفة، علشان لو حصل error في add/remove
/// أيقونة البوكمارك ما ترجعش "مش محفوظ" غلط.
class WatchlistError extends WatchlistState {
  final String message;

  @override
  final List<SavedMovieEntity> movies;

  const WatchlistError(this.message, {this.movies = const []});

  @override
  List<Object?> get props => [message, movies];
}