import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/common_widgets/movie_vet_images.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/widgets/open_trailer.dart';
import 'package:movies_app/features/favorites/domain/entities/saved_movie_entity.dart';
import 'package:movies_app/features/favorites/presentation/widgets/bookmark_button.dart';
class MovieHeader extends StatelessWidget {
  const MovieHeader({super.key, required this.movie});

  final MovieDetailsEntity movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
     MovieNetImage(url: movie.largeCoverImage, height: 480.h, radius: 0),
       Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.95),
                ],
                stops: const [0.5, 1],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
               BookmarkButton(
  movie: SavedMovieEntity(
    movieId: movie.id,
    title: movie.title,
    posterPath: movie.largeCoverImage,
    rating: movie.rating,
    savedAt: DateTime.now(),
  ),
),
              ],
              ),
              ),
              ),
        Positioned.fill(
          child: Center(
            child: IconButton(
              iconSize: 72.r,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.play_circle_fill,
                color: AppColors.primary,
              ),
              onPressed: () => openTrailer(context, movie.ytTrailerCode),
            ),
          ),
        ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 8.h,
          child: Column(
            children: [
              Text(
                movie.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${movie.year}',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
