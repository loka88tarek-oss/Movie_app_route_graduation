import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/movie_card.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/open_movie_details.dart';

class SearchResultsGrid extends StatelessWidget {
  const SearchResultsGrid({super.key, required this.movies});

  final List<dynamic> movies;

  @override
  Widget build(BuildContext context) {
    final spacing = 12.w;
    final cardWidth = (MediaQuery.of(context).size.width - 32.w - spacing) / 2;
    final cardHeight = cardWidth * 1.5;

    return GridView.builder(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: cardHeight,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          movie: movie,
          width: cardWidth,
          height: cardHeight,
          onTap: () => openMovieDetails(context, movie.id),
        );
      },
    );
  }
}
