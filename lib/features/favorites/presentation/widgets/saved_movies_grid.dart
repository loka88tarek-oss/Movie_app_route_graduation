import 'package:flutter/material.dart';
import '../../domain/entities/saved_movie_entity.dart';
import 'empty_state_widget.dart';
import 'movie_poster_card.dart';

class SavedMoviesGrid extends StatelessWidget {
  final List<SavedMovieEntity> movies;
  final String emptyMessage;
  final void Function(SavedMovieEntity movie)? onMovieTap;

  const SavedMoviesGrid({
    super.key,
    required this.movies,
    required this.emptyMessage,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return EmptyStateWidget(message: emptyMessage);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MoviePosterCard(
          movie: movie,
          onTap: onMovieTap == null ? null : () => onMovieTap!(movie),
        );
      },
    );
  }
}