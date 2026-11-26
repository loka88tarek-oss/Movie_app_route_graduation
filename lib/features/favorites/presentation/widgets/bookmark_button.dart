import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/saved_movie_entity.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class BookmarkButton extends StatelessWidget {
  final SavedMovieEntity movie;

  const BookmarkButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final isSaved = state.isSaved(movie.movieId);
        return IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? AppColors.primary : AppColors.textPrimary,
          ),
          onPressed: () {
 
  final bloc = context.read<WatchlistBloc>();
            if (isSaved) {
              bloc.add(RemoveMovieFromWatchlist(movie.movieId));
            } else {
              bloc.add(AddMovieToWatchlist(movie));
            }
          },
        );
      },
    );
  }
}