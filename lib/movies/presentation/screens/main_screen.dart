 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/enums/genere_enum.dart';
import 'package:movies_app/core/storage/app_prefs.dart';
import 'package:movies_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_bloc.dart';
import 'package:movies_app/movies/presentation/bloc/browse/browse_event.dart';
import 'package:movies_app/movies/presentation/screens/browse_tab/browse_screen.dart';
import 'package:movies_app/movies/presentation/screens/home_tab/home_screen.dart';
import 'package:movies_app/movies/presentation/screens/search_tab/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.prefs});

  final AppPrefs prefs;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;
  GenereEnum? _browseGenre;

  @override
  void initState() {
    super.initState();
    final saved = widget.prefs.lastBrowseGenre;
    _browseGenre =
        (saved != null ? GenereEnum.fromApiName(saved) : null) ??
        GenereEnum.action;
    context.read<BrowseBloc>().add(SelectGenreEvent(_browseGenre?.apiName));
  }

  List<Widget> tabs() => [
    HomeScreen(onSeeMore: _openBrowseWithGenre),
    SearchScreen(),
    BrowseScreen(
      selectedGenre: _browseGenre,
      onGenreSelected: _onGenreSelected,
    ),
    const ProfileScreen(),
  ];

  void _onGenreSelected(GenereEnum? genre) {
    setState(() => _browseGenre = genre);
    context.read<BrowseBloc>().add(SelectGenreEvent(genre?.apiName));
    if (genre == null) {
      widget.prefs.clearLastBrowseGenre();
    } else {
      widget.prefs.saveLastBrowseGenre(genre.apiName);
    }
  }

  void _openBrowseWithGenre(String genreName) {
    _onGenreSelected(GenereEnum.fromApiName(genreName));
    setState(() => currentTabIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentTabIndex, children: tabs()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex,
        onTap: (value) {
          currentTabIndex = value;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}