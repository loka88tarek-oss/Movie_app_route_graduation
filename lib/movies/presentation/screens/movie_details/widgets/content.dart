import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_badge.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_genere_chip.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_section_tile.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_vet_images.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/movie_cast_tile.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/movie_details_header.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/movie_similar_section.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/open_trailer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/favorites/domain/entities/saved_movie_entity.dart';
import 'package:movies_app/features/favorites/presentation/bloc/history_bloc.dart';
import 'package:movies_app/features/favorites/presentation/bloc/history_event.dart';

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.movie,
    this.similarMovies = const [],
  });

  final MovieDetailsEntity movie;
  final List<MovieEntity> similarMovies;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          MovieHeader(movie: movie),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    onPressed: () {
                      context.read<HistoryBloc>().add(
                            AddMovieToHistory(
                              SavedMovieEntity(
                                movieId: movie.id,
                                title: movie.title,
                                posterPath: movie.largeCoverImage,
                                rating: movie.rating,
                                savedAt: DateTime.now(),
                              ),
                            ),
                          );
                      openTrailer(context, movie.ytTrailerCode);
                    },                    child: const Text(
                      'Watch',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    MovieBadge(
                      icon: Icons.favorite,
                      value: '${movie.likeCount}',
                    ),
                    SizedBox(width: 10.w),
                    MovieBadge(icon: Icons.timer, value: '${movie.runtime}'),
                    SizedBox(width: 10.w),
                    MovieBadge(icon: Icons.star, value: '${movie.rating}'),
                  ],
                ),
                if (movie.screenshots.isNotEmpty) ...[
                  const MovieSectionTitle('Screen Shots'),
                  for (final url in movie.screenshots)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: MovieNetImage(
                        url: url,
                        height: 160.h,
                        radius: 12.r,
                      ),
                    ),
                ],
                MovieSimilarSection(movies: similarMovies),
                const MovieSectionTitle('Summary'),
                Text(
                  movie.summary,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
                if (movie.cast.isNotEmpty) ...[
                  const MovieSectionTitle('Cast'),
                  for (final member in movie.cast)
                    MovieCastTile(member: member),
                ],
                const MovieSectionTitle('Genres'),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final g in movie.genres) MovieGenreChip(label: g),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
