import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'history_tab_view.dart';
import 'watchlist_tab_view.dart';

 
class ProfileTabsSection extends StatelessWidget {
  const ProfileTabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textPrimary,
            dividerColor: AppColors.divider,
            tabs: [
              Tab(
                icon: Icon(Icons.list, color: AppColors.primary),
                text: 'Watch List',
              ),
              Tab(
                icon: Icon(Icons.folder, color: AppColors.primary),
                text: 'History',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                WatchlistTabView(),
                HistoryTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}