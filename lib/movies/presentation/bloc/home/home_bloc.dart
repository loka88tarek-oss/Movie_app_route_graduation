import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/domain/usecases/get_movie_use_case.dart';
import 'package:movies_app/movies/presentation/bloc/home/home_event.dart';
import 'package:movies_app/movies/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMoviesUseCase getMoviesUseCase;

  static const int _carouselLimit = 10;
  static const int _genreLimit = 20;

  static const List<String> homeGenres = [
    'Action',
    'Comedy',
    'Drama',
    'Animation',
    'Horror',
  ];

  HomeBloc(this.getMoviesUseCase) : super(const HomeState()) {
    on<LoadMoviesEvent>(_onLoadMovies);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      HomeState(
        sections: homeGenres.map((g) => GenreSectionState(genre: g)).toList(),
      ),
    );

    await Future.wait([
      _loadCarousel(emit),
      for (var i = 0; i < homeGenres.length; i++) _loadGenre(i, emit),
    ]);
  }

  Future<void> _loadCarousel(Emitter<HomeState> emit) async {
    try {
      final movies = await getMoviesUseCase(
        page: 1,
        limit: _carouselLimit,
        sortBy: 'rating',
      );
      emit(state.copyWith(isCarouselLoading: false, carouselMovies: movies));
    } catch (e) {
      emit(
        state.copyWith(
          isCarouselLoading: false,
          carouselError: 'Failed to load movies: $e',
        ),
      );
    }
  }

  Future<void> _loadGenre(int index, Emitter<HomeState> emit) async {
    final genre = homeGenres[index];
    try {
      final movies = await getMoviesUseCase(
        page: 1,
        limit: _genreLimit,
        genre: genre,
      );
      _updateSection(
        index,
        emit,
        (s) => s.copyWith(isLoading: false, movies: movies),
      );
    } catch (e) {
      _updateSection(
        index,
        emit,
        (s) => s.copyWith(
          isLoading: false,
          error: 'Failed to load $genre movies: $e',
        ),
      );
    }
  }

  void _updateSection(
    int index,
    Emitter<HomeState> emit,
    GenreSectionState Function(GenreSectionState) update,
  ) {
    final sections = [...state.sections];
    sections[index] = update(sections[index]);
    emit(state.copyWith(sections: sections));
  }
}
