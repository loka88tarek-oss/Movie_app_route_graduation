import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/movie_card.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/open_movie_details.dart';

class GenreSection extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;
  final VoidCallback? onSeeMore;

  const GenreSection({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              GestureDetector(
                onTap: onSeeMore,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.w,
                  children: [
                    Text(
                      'See More',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.textColorHome,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.r,
                      color: AppColors.textColorHome,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: movies.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                width: 140.w,
                height: 220.h,
                onTap: () => openMovieDetails(context, movies[index].id),
              );
            },
          ),
        ),
      ],
    );
  }
}
