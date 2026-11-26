import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_movie_entity.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class ClearHistoryState extends HistoryEvent {
  const ClearHistoryState();
}

class AddMovieToHistory extends HistoryEvent {
  final SavedMovieEntity movie;

  const AddMovieToHistory(this.movie);

  @override
  List<Object?> get props => [movie];
}

class ClearAllHistory extends HistoryEvent {
  const ClearAllHistory();
}