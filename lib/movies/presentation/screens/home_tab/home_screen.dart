import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/genere_widget.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/header_widget.dart';
import 'package:movies_app/movies/presentation/bloc/home/home_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/home/home_event.dart';
import 'package:movies_app/movies/presentation/bloc/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String genre) onSeeMore;

  const HomeScreen({super.key, required this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  SizedBox(height: 16.h),
                  for (final section in state.sections) ...[
                    _buildGenreSection(context, section),
                    SizedBox(height: 16.h),
                  ],
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state) {
    if (state.isCarouselLoading) {
      return SizedBox(
        height: 645.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.carouselError.isNotEmpty) {
      return SizedBox(
        height: 645.h,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.carouselError),
              TextButton(
                onPressed:
                    () => context.read<HomeBloc>().add(LoadMoviesEvent()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.carouselMovies.isEmpty) {
      return SizedBox(height: 645.h);
    }
    return HomeHeader(movies: state.carouselMovies);
  }

  Widget _buildGenreSection(BuildContext context, GenreSectionState section) {
    if (section.isLoading) {
      return SizedBox(
        height: 260.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (section.error.isNotEmpty) {
      return SizedBox(
        height: 260.h,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(section.error),
              TextButton(
                onPressed:
                    () => context.read<HomeBloc>().add(LoadMoviesEvent()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (section.movies.isEmpty) {
      return const SizedBox.shrink();
    }
    return GenreSection(
      title: section.genre,
      movies: section.movies,
      onSeeMore: () => onSeeMore(section.genre),
    );
  }
}
