import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/movie_card.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/open_movie_details.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_section_tile.dart';

class MovieSimilarSection extends StatelessWidget {
  const MovieSimilarSection({super.key, required this.movies});

  final List<MovieEntity> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final items = movies.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MovieSectionTitle('Similar'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.69,
          ),
          itemBuilder: (context, index) {
            final movie = items[index];
            return MovieCard(
              movie: movie,
              width: double.infinity,
              height: double.infinity,
              onTap: () => openMovieDetails(context, movie.id),
            );
          },
        ),
      ],
    );
  }
}
