import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/enums/genere_enum.dart';

import 'package:movies_app/movies/presentation/bloc/browse/browse_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_event.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_state.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/widgets/movie_card.dart';
import 'package:movies_app/movies/presentation/screens/movie_details/open_movie_details.dart';

class BrowseScreen extends StatefulWidget {
  final GenereEnum? selectedGenre;
  final void Function(GenereEnum?) onGenreSelected;

  const BrowseScreen({
    super.key,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BrowseBloc>().add(const LoadBrowseEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<BrowseBloc>().add(const LoadMoreBrowseEvent());
    }
  }

  void _onGenreTap(GenereEnum genre) {
    widget.onGenreSelected(widget.selectedGenre == genre ? null : genre);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          _buildChips(),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<BrowseBloc, BrowseState>(
              builder: (context, state) {
                if (state is BrowseLoading || state is BrowseInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BrowseError) {
                  return _buildError(state.message);
                }
                if (state is BrowseLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(child: Text('No movies found'));
                  }
                  return _buildGrid(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: GenereEnum.values.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final genre = GenereEnum.values[index];
          final isSelected = genre == widget.selectedGenre;
          return GestureDetector(
            onTap: () => _onGenreTap(genre),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                genre.apiName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : AppColors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BrowseLoaded state) {
    const columns = 2;
    final spacing = 16.w;
    final cardWidth = (1.sw - spacing * (columns + 1)) / columns;
    final cardHeight = cardWidth * 1.5;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: cardHeight,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final movie = state.movies[index];
              return MovieCard(
                movie: movie,
                width: cardWidth,
                height: cardHeight,

                onTap: () => openMovieDetails(context, movie.id),
              );
            }, childCount: state.movies.length),
          ),
        ),
        if (state.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed:
                () => context.read<BrowseBloc>().add(
                  SelectGenreEvent(widget.selectedGenre?.apiName),
                ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
