import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../domain/entities/saved_movie_entity.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import 'error_retry_view.dart';
import 'saved_movies_grid.dart';

/// محتوى تاب الـ Watch List. بيتحط جوه TabBarView في شاشة الـ Profile.
class WatchlistTabView extends StatelessWidget {
  final void Function(SavedMovieEntity movie)? onMovieTap;

  const WatchlistTabView({super.key, this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistLoading) {
          return const CustomLoadingIndicator();
        }
        // لو فيه error وفي نفس الوقت عندنا قائمة معروفة، نعرض القائمة.
        if (state is WatchlistError && state.movies.isEmpty) {
          return ErrorRetryView(
            message: state.message,
            onRetry: () =>
                context.read<WatchlistBloc>().add(const LoadWatchlist()),
          );
        }
        return SavedMoviesGrid(
          movies: state.movies,
          emptyMessage: 'No movies in your watch list',
          onMovieTap: onMovieTap,
        );
      },
    );
  }
}