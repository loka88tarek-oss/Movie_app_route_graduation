import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../domain/entities/saved_movie_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import 'error_retry_view.dart';
import 'saved_movies_grid.dart';

/// محتوى تاب الـ History. بيتحط جوه TabBarView في شاشة الـ Profile.
class HistoryTabView extends StatelessWidget {
  final void Function(SavedMovieEntity movie)? onMovieTap;

  const HistoryTabView({super.key, this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const CustomLoadingIndicator();
        }
        if (state is HistoryError) {
          return ErrorRetryView(
            message: state.message,
            onRetry: () => context.read<HistoryBloc>().add(const LoadHistory()),
          );
        }
        final List<SavedMovieEntity> movies =
            state is HistoryLoaded ? state.movies : const [];
        return SavedMoviesGrid(
          movies: movies,
          emptyMessage: 'No history yet',
          onMovieTap: onMovieTap,
        );
      },
    );
  }
}