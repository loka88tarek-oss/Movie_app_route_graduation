import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/domain/usecases/search_movie_use_case.dart';

import 'package:stream_transform/stream_transform.dart';

import 'search_event.dart';
import 'search_state.dart';

const _debounceDuration = Duration(milliseconds: 500);

EventTransformer<E> debounceRestartable<E>() {
  return (events, mapper) {
    return restartable<E>().call(events.debounce(_debounceDuration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  static const int _limit = 20;

  SearchBloc(this.searchMoviesUseCase) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged, transformer: debounceRestartable());
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    try {
      final movies = await searchMoviesUseCase(
        page: 1,
        limit: _limit,
        query: query,
      );

      if (movies.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(movies: movies, query: query));
      }
    } catch (e) {
      emit(SearchError('Failed to search movies: $e'));
    }
  }
}
