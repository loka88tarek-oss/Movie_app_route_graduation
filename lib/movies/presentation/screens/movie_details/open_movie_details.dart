import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/movies/domain/usecases/get_movie_details_use_case.dart';
import 'package:movies_app/movies/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_event.dart';

import 'package:movies_app/movies/presentation/screens/movie_details/movie_details_screen.dart';

void openMovieDetails(BuildContext context, int movieId) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (_) => BlocProvider(
            create:
                (_) => MovieDetailsBloc(
                  context.read<GetMovieDetailsUseCase>(),
                  context.read<GetSimilarMoviesUseCase>(),
                )..add(LoadMovieDetailsEvent(movieId)),
            child: MovieDetailsScreen(movieId: movieId),
          ),
    ),
  );
}
