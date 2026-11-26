import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/domain/usecases/get_movie_details_use_case.dart';
import 'package:movies_app/movies/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_event.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;
  final GetSimilarMoviesUseCase getSimilarMoviesUseCase;

  MovieDetailsBloc(this.getMovieDetailsUseCase, this.getSimilarMoviesUseCase)
    : super(const MovieDetailsInitial()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(const MovieDetailsLoading());
    try {
      final detailsFuture = getMovieDetailsUseCase(id: event.movieId);
      final similarFuture = getSimilarMoviesUseCase(
        id: event.movieId,
      ).catchError((_) => <MovieEntity>[]);

      final (movie, similar) = await (detailsFuture, similarFuture).wait;

      emit(MovieDetailsLoaded(movie, similarMovies: similar));
    } catch (e) {
      emit(MovieDetailsError("There is an error $e"));
    }
  }
}
