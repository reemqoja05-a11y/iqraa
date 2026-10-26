import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'achievements_screen.dart';
import 'groups_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import '../widgets/widgets.dart';

/// Main application shell holding the four bottom-navigation tabs.
///
/// The tabs are: الرئيسية (Home), المكتبة (Library), المجموعات (Groups),
/// إنجازاتي (Achievements) — matching the Stitch designs exactly.
class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  AppDestination _selected = AppDestination.home;

  final _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    const GroupsScreen(),
    const AchievementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _screens[_selected.index],
        bottomNavigationBar: AppBottomNav(
          selected: _selected,
          onDestinationSelected: (destination) {
            setState(() => _selected = destination);
          },
        ),
      ),
    );
  }
}
