import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_movie_entity.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class ClearWatchlist extends WatchlistEvent {
  const ClearWatchlist();
}

class AddMovieToWatchlist extends WatchlistEvent {
  final SavedMovieEntity movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistEvent {
  final int movieId;

  const RemoveMovieFromWatchlist(this.movieId);

  @override
  List<Object?> get props => [movieId];
}