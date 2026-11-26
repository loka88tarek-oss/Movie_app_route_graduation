import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/movie_rating_entity.dart';
import '../bloc/rating_bloc.dart';
import '../bloc/rating_event.dart';
import '../bloc/rating_state.dart';
import 'rating_bottom_sheet.dart';

/// زرار صغير بيتحط في Movie Details جنب الـ chips (❤ 15 / ⏱ 90 / ⭐ 7.6).
/// بيحمّل تقييم اليوزر للفيلم لوحده، وبيفتح الـ bottom sheet.
class RateMovieButton extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const RateMovieButton({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<RateMovieButton> createState() => _RateMovieButtonState();
}

class _RateMovieButtonState extends State<RateMovieButton> {
  @override
  void initState() {
    super.initState();
    context.read<RatingBloc>().add(LoadMovieRating(widget.movieId));
  }

  @override
  void didUpdateWidget(covariant RateMovieButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movieId != widget.movieId) {
      context.read<RatingBloc>().add(LoadMovieRating(widget.movieId));
    }
  }

  /// تقييم اليوزر للفيلم ده بس، ولو الـ state بتاعة فيلم تاني بنتجاهلها.
  MovieRatingEntity? _myRating(RatingState state) {
    if (state is RatingLoaded && state.movieId == widget.movieId) {
      return state.rating;
    }
    if (state is RatingSubmitting && state.movieId == widget.movieId) {
      return state.rating;
    }
    if (state is RatingError && state.movieId == widget.movieId) {
      return state.rating;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingBloc, RatingState>(
      builder: (context, state) {
        final mine = _myRating(state);
        final isLoading =
            state is RatingLoading && state.movieId == widget.movieId;

        return Material(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isLoading
                ? null
                : () => showRatingBottomSheet(
                      context,
                      movieId: widget.movieId,
                      movieTitle: widget.movieTitle,
                    ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    mine != null
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: mine != null
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    mine != null ? '${mine.rating}/10' : 'Rate',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}