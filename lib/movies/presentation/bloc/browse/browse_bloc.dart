import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/movies/domain/usecases/get_movie_use_case.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_event.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final GetMoviesUseCase getMoviesUseCase;
  static const int _limit = 20;
  int _currentPage = 1;

  BrowseBloc(this.getMoviesUseCase) : super(const BrowseInitial()) {
    on<LoadBrowseEvent>(_onLoadBrowse);
    on<SelectGenreEvent>(_onSelectGenre);
    on<LoadMoreBrowseEvent>(_onLoadMoreBrowse);
  }

  Future<void> _onLoadBrowse(
    LoadBrowseEvent event,
    Emitter<BrowseState> emit,
  ) async {
    await _loadFirstPage(null, emit);
  }

  Future<void> _onSelectGenre(
    SelectGenreEvent event,
    Emitter<BrowseState> emit,
  ) async {
    await _loadFirstPage(event.genre, emit);
  }

  Future<void> _loadFirstPage(String? genre, Emitter<BrowseState> emit) async {
    _currentPage = 1;
    emit(const BrowseLoading());
    try {
      final movies = await getMoviesUseCase(
        page: _currentPage,
        limit: _limit,
        genre: genre,
      );
      emit(
        BrowseLoaded(
          movies: movies,
          selectedGenre: genre,
          hasReachedMax: movies.length < _limit,
        ),
      );
    } catch (e) {
      emit(BrowseError('Failed to load movies: $e'));
    }
  }

  Future<void> _onLoadMoreBrowse(
    LoadMoreBrowseEvent event,
    Emitter<BrowseState> emit,
  ) async {
    final current = state;
    if (current is! BrowseLoaded ||
        current.hasReachedMax ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    final nextPage = _currentPage + 1;
    try {
      final newMovies = await getMoviesUseCase(
        page: nextPage,
        limit: _limit,
        genre: current.selectedGenre,
      );
      _currentPage = nextPage;
      emit(
        current.copyWith(
          movies: [...current.movies, ...newMovies],
          hasReachedMax: newMovies.length < _limit,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
