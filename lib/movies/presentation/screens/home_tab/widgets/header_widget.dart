import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/movie_card.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/open_movie_details.dart';

class HomeHeader extends StatefulWidget {
  final List<MovieEntity> movies;

  const HomeHeader({super.key, required this.movies});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.6);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMovie = widget.movies[_currentIndex];

    return SizedBox(
      width: 1.sw,
      height: 645.h,
      child: Stack(
        children: [
          // 1) الخلفية
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: CachedNetworkImage(
                key: ValueKey(currentMovie.id),
                imageUrl: currentMovie.backgroundImage,
                width: 1.sw,
                height: 645.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset(
                AppAssets.homeCaroselSliderBg,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            height: 340.h,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.movies.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final movie = widget.movies[index];
                return Center(
                  child: AnimatedScale(
                    scale: index == _currentIndex ? 1.0 : 0.85,
                    duration: const Duration(milliseconds: 250),
                    child: MovieCard(
                      movie: movie,
                      width: 200.w,
                      height: 300.h,
                      onTap: () => openMovieDetails(context, movie.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
