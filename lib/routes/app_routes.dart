import 'package:flutter/material.dart';

import '../views/screens/book_details_screen.dart';
import '../views/screens/create_group_screen.dart';
import '../views/screens/group_details_screen.dart';
import '../views/screens/home_shell_screen.dart';
import '../views/screens/library_screen.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/onboarding_screen.dart';
import '../views/screens/reading_plan_progress_screen.dart';
import '../views/screens/settings_profile_screen.dart';

/// Named routes used by the Iqra app.
///
/// Navigation is handled by Flutter's built-in named-route mechanism so no
/// extra navigation package is needed.
class AppRoutes {
  // Entry points
  static const String onboarding = '/';
  static const String login = '/login';
  static const String home = '/home';

  // Screens
  static const String library = '/library';
  static const String bookDetails = '/book-details';
  static const String readingPlanProgress = '/reading-plan-progress';
  static const String createGroup = '/create-group';
  static const String groupDetails = '/group-details';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeShellScreen(),
    library: (_) => const LibraryScreen(),
    bookDetails: (_) => const BookDetailsScreen(),
    readingPlanProgress: (_) => const ReadingPlanProgressScreen(),
    createGroup: (_) => const CreateGroupScreen(),
    groupDetails: (_) => const GroupDetailsScreen(),
    settings: (_) => const SettingsProfileScreen(),
  };
}
