import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../core/widgets/custom_outlined_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../favorites/presentation/bloc/history_bloc.dart';
import '../../../favorites/presentation/bloc/history_state.dart';
import '../../../favorites/presentation/bloc/watchlist_bloc.dart';
import '../../../favorites/presentation/bloc/watchlist_state.dart';
import '../../../favorites/presentation/widgets/history_tab_view.dart';
import '../../../favorites/presentation/widgets/watchlist_tab_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<ProfileBloc>().add(
            LoadProfile(
              uid: authState.user.uid,
              email: authState.user.email,
              displayName: authState.user.displayName,
            ),
          );
    }
  }

  ImageProvider _resolveAvatar(String avatarKey) {
    if (avatarKey.startsWith('http')) {
      return NetworkImage(avatarKey);
    }
    if (avatarKey.startsWith('/') || avatarKey.contains(r':\')) {
      final file = File(avatarKey);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    if (avatarKey == 'avatar_2') {
      return const AssetImage(AppAssets.avatar2);
    }
    if (avatarKey == 'avatar_3') {
      return const AssetImage(AppAssets.avatar3);
    }
    return const AssetImage(AppAssets.avatar1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CustomLoadingIndicator());
            }

            final ProfileEntity profile;
            if (state is ProfileLoaded) {
              profile = state.profile;
            } else if (state is ProfileUpdatedSuccess) {
              profile = state.profile;
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No profile data found',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      title: 'Retry',
                      width: 140,
                      height: 44,
                      onPressed: _loadProfile,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildProfileHeader(profile),
                   
                  _buildActionButtons(context),
                 
                  _buildTabSection(profile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: _resolveAvatar(profile.avatarKey),
              ),
              const SizedBox(height: 12),
              Text(
                profile.displayName.isNotEmpty ? profile.displayName : 'John Safwat',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),
             
            ],
          ),Spacer(),
           Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<WatchlistBloc, WatchlistState>(
                  builder: (_, s) => _buildStatItem(
                    '${s.movies.length}',
                    AppStrings.wishList,
                  ),
                ),
                const SizedBox(width: 30),
                BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (_, s) => _buildStatItem(
                    '${s is HistoryLoaded ? s.movies.length : 0}',
                    AppStrings.history,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }///////////////////////////////////////////

  Widget _buildStatItem(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomElevatedButton(
              title: AppStrings.editProfile,
              height: 48,
              onPressed: () => context.push(AppRoutes.editProfile),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CustomOutlinedButton(
              title: 'Exit',
              height: 48,
              backgroundColor: Colors.red,
              borderColor:Colors.red,
              textColor: Colors.white,
              icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
              onPressed: () => _confirmLogout(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const SignOutRequested());
              context.read<ProfileBloc>().add(const ClearProfile());
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(ProfileEntity profile) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
            ),
            child: const TabBar(
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor:  AppColors.textPrimary, 
 
               tabs: [
                Tab(
                  icon: Icon(Icons.menu,color: AppColors.primary,),
                  text: AppStrings.wishList,
                  
                ),
                Tab(
                  icon: Icon(Icons.folder,color: AppColors.primary,),
                  text: AppStrings.history,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 320,
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