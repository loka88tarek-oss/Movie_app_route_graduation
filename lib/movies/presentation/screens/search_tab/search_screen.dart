import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/movies/presentation/bloc/search/search_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/search/search_event.dart';
import 'package:movies_app/movies/presentation/bloc/search/search_state.dart';
import 'package:movies_app/movies/presentation/screens/search_tab/widgets/search_feild.dart';

import 'package:movies_app/movies/presentation/screens/search_tab/widgets/search_message.dart';
import 'package:movies_app/movies/presentation/screens/search_tab/widgets/search_result_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<SearchBloc>().add(SearchQueryChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            SearchField(controller: _controller, onChanged: _onChanged),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SearchLoaded) {
                    return SearchResultsGrid(movies: state.movies);
                  }
                  if (state is SearchEmpty) {
                    return const SearchMessage(text: 'No movies found');
                  }
                  if (state is SearchError) {
                    return SearchMessage(
                      text: state.message,
                      onRetry: () => _onChanged(_controller.text),
                    );
                  }
                  return Image.asset(
                    AppAssets.emptySearchBg,
                    width: 200.w,
                    height: 200.h,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
