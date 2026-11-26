import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';

import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_event.dart';
import 'package:movies_app/movies/presentation/bloc/movie_details/movie_details_state.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/content.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoaded) {
              return Content(
                movie: state.movie,
                similarMovies: state.similarMovies,
              );
            }
            if (state is MovieDetailsError) {
              return SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        // لازم يطابق constructor الـ event بتاعك
                        onPressed:
                            () => context.read<MovieDetailsBloc>().add(
                              LoadMovieDetailsEvent(movieId),
                            ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
