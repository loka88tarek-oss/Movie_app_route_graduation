import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie_rating_entity.dart';
import '../../domain/usecases/delete_movie_rating.dart';
import '../../domain/usecases/get_movie_rating.dart';
import '../../domain/usecases/rate_movie.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final GetMovieRating getMovieRating;
  final RateMovie rateMovie;
  final DeleteMovieRating deleteMovieRating;

  RatingBloc({
    required this.getMovieRating,
    required this.rateMovie,
    required this.deleteMovieRating,
  }) : super(const RatingInitial()) {
    on<LoadMovieRating>(_onLoad);
    on<SubmitMovieRating>(_onSubmit);
    on<RemoveMovieRating>(_onRemove);
  }

  /// آخر تقييم معروف للفيلم ده من الـ state الحالية (لو الـ state تخص نفس الفيلم).
  MovieRatingEntity? _currentRating(int movieId) {
    final s = state;
    if (s is RatingLoaded && s.movieId == movieId) return s.rating;
    if (s is RatingSubmitting && s.movieId == movieId) return s.rating;
    if (s is RatingError && s.movieId == movieId) return s.rating;
    return null;
  }

  Future<void> _onLoad(
    LoadMovieRating event,
    Emitter<RatingState> emit,
  ) async {
    emit(RatingLoading(event.movieId));
    final result = await getMovieRating(event.movieId);
    result.fold(
      (failure) => emit(RatingError(failure.message, movieId: event.movieId)),
      (rating) => emit(RatingLoaded(event.movieId, rating)),
    );
  }

  Future<void> _onSubmit(
    SubmitMovieRating event,
    Emitter<RatingState> emit,
  ) async {
    final movieId = event.rating.movieId;
    final previous = _currentRating(movieId);
    emit(RatingSubmitting(movieId, previous));

    final result = await rateMovie(event.rating);
    result.fold(
      (failure) => emit(
        RatingError(failure.message, movieId: movieId, rating: previous),
      ),
      (_) => emit(RatingLoaded(movieId, event.rating)),
    );
  }

  Future<void> _onRemove(
    RemoveMovieRating event,
    Emitter<RatingState> emit,
  ) async {
    final previous = _currentRating(event.movieId);
    emit(RatingSubmitting(event.movieId, previous));

    final result = await deleteMovieRating(event.movieId);
    result.fold(
      (failure) => emit(
        RatingError(failure.message, movieId: event.movieId, rating: previous),
      ),
      (_) => emit(RatingLoaded(event.movieId, null)),
    );
  }
}