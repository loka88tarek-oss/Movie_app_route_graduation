import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/movie_rating_entity.dart';
import '../bloc/rating_bloc.dart';
import '../bloc/rating_event.dart';
import '../bloc/rating_state.dart';

/// بيفتح الـ bottom sheet بتاع التقييم.
/// بنمرر نفس الـ RatingBloc بـ BlocProvider.value علشان الـ sheet
/// بيتبني في route تاني ومش بالضرورة يشوف الـ provider.
Future<void> showRatingBottomSheet(
  BuildContext context, {
  required int movieId,
  required String movieTitle,
}) {
  final bloc = context.read<RatingBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: RatingBottomSheet(movieId: movieId, movieTitle: movieTitle),
    ),
  );
}

class RatingBottomSheet extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const RatingBottomSheet({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  static const int _maxRating = 10;

  final _reviewController = TextEditingController();
  int _rating = 0;
  bool _hadRating = false;
  bool _waiting = false; // اليوزر ضغط Submit/Remove وبنستنى النتيجة
  String? _error;

  @override
  void initState() {
    super.initState();
    final state = context.read<RatingBloc>().state;
    if (state is RatingLoaded &&
        state.movieId == widget.movieId &&
        state.rating != null) {
      _hadRating = true;
      _rating = state.rating!.rating;
      _reviewController.text = state.rating!.review;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _waiting = true;
      _error = null;
    });
    context.read<RatingBloc>().add(
          SubmitMovieRating(
            MovieRatingEntity(
              movieId: widget.movieId,
              rating: _rating,
              review: _reviewController.text.trim(),
              ratedAt: DateTime.now(),
            ),
          ),
        );
  }

  void _remove() {
    setState(() {
      _waiting = true;
      _error = null;
    });
    context.read<RatingBloc>().add(RemoveMovieRating(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingBloc, RatingState>(
      listener: (context, state) {
        if (!_waiting) return;
        if (state is RatingLoaded && state.movieId == widget.movieId) {
          Navigator.of(context).pop();
        } else if (state is RatingError) {
          setState(() {
            _waiting = false;
            _error = state.message;
          });
        }
      },
      builder: (context, state) {
        final isBusy =
            state is RatingSubmitting && state.movieId == widget.movieId;

        return Padding(
          // علشان الكيبورد ما يغطيش الـ TextField
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.movieTitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(_maxRating, (i) {
                    final value = i + 1;
                    final selected = value <= _rating;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: isBusy
                            ? null
                            : () => setState(() => _rating = value),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Icon(
                              selected
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 32,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textHint,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  _rating == 0
                      ? 'Tap a star to rate'
                      : '$_rating / $_maxRating',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  enabled: !isBusy,
                  maxLines: 3,
                  maxLength: 300,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Write a review (optional)',
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: (_rating == 0 || isBusy) ? null : _submit,
                  child: isBusy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : Text(_hadRating ? 'Update rating' : 'Submit'),
                ),
                if (_hadRating)
                  TextButton(
                    onPressed: isBusy ? null : _remove,
                    child: const Text(
                      'Remove rating',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}