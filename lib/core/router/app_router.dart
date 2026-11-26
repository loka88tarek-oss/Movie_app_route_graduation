import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/storage/app_prefs.dart';
import 'package:movies_app/movies/presentation/screens/main_screen.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
}

/// Bridges BLoC Stream to GoRouter's Listenable for reactive navigation.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter createRouter(
    AuthBloc authBloc,
    SharedPrefsHelper sharedPrefsHelper,
    AppPrefs moviesPrefs,
  ) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final currentLocation = state.matchedLocation;

        final isSplash = currentLocation == AppRoutes.splash;
        final isAuthRoute = currentLocation == AppRoutes.login ||
            currentLocation == AppRoutes.register ||
            currentLocation == AppRoutes.forgotPassword;
        final isOnboarding = currentLocation == AppRoutes.onboarding;

        // While on splash screen, let the splash animation run its course
        if (isSplash) {
          return null;
        }

        // 1. Authenticated: redirect away from auth & onboarding screens to Home
        if (authState is Authenticated) {
          if (isAuthRoute || isOnboarding) {
            return AppRoutes.home;
          }
          return null;
        }

        // 2. Unauthenticated: protect private routes (Home, Profile, etc.)
        if (authState is Unauthenticated || authState is AuthError) {
          final isProtectedRoute = currentLocation == AppRoutes.home ||
              currentLocation == AppRoutes.profile ||
              currentLocation == AppRoutes.editProfile;

          if (isProtectedRoute) {
            final hasSeenOnboarding = sharedPrefsHelper.getHasSeenOnboarding();
            return hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding;
          }
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => MainScreen(prefs: moviesPrefs),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
      ],
    );
  }
}