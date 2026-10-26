import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iqraa/theme/app_theme.dart';
import 'package:iqraa/views/screens/achievements_screen.dart';
import 'package:iqraa/views/screens/book_details_screen.dart';
import 'package:iqraa/views/screens/create_group_screen.dart';
import 'package:iqraa/views/screens/group_details_screen.dart';
import 'package:iqraa/views/screens/groups_screen.dart';
import 'package:iqraa/views/screens/home_screen.dart';
import 'package:iqraa/views/screens/home_shell_screen.dart';
import 'package:iqraa/views/screens/library_screen.dart';
import 'package:iqraa/views/screens/login_screen.dart';
import 'package:iqraa/views/screens/onboarding_screen.dart';
import 'package:iqraa/views/screens/reading_plan_progress_screen.dart';
import 'package:iqraa/views/screens/settings_profile_screen.dart';

/// Responsive-layout regression harness.
///
/// Every screen is pumped on a set of viewports (narrow phone → tablet) and
/// with a set of text scales (1.0 → 2.0). Any `RenderFlex` overflow or layout
/// assertion raised while the screen is laid out and scrolled is collected
/// and reported as a test failure, together with the offending widget.
class _Target {
  final String name;
  final Widget screen;
  const _Target(this.name, this.screen);
}

const List<Size> _viewports = <Size>[
  Size(320, 568), // narrow phone
  Size(360, 640), // typical Android phone
  Size(411, 891), // large phone
  Size(768, 1024), // tablet
];

const List<double> _textScales = <double>[1.0, 1.3, 1.5, 2.0];

final List<_Target> _targets = <_Target>[
  _Target('Onboarding', const OnboardingScreen()),
  _Target('Login', const LoginScreen()),
  _Target('HomeShell', const HomeShellScreen()),
  _Target('Home', const HomeScreen()),
  _Target('Library', const LibraryScreen()),
  _Target('Groups', const GroupsScreen()),
  _Target('Achievements', const AchievementsScreen()),
  _Target('BookDetails', const BookDetailsScreen()),
  _Target('GroupDetails', const GroupDetailsScreen()),
  _Target('CreateGroup', const CreateGroupScreen()),
  _Target('ReadingPlanProgress', const ReadingPlanProgressScreen()),
  _Target('SettingsProfile', const SettingsProfileScreen()),
];

void main() {
  setUpAll(_loadArabicFont);

  testWidgets('all screens lay out without overflow on phones and tablets',
      (WidgetTester tester) async {
    final List<String> failures = <String>[];

    for (final _Target target in _targets) {
      for (final Size size in _viewports) {
        for (final double scale in _textScales) {
          final List<String> errors = await _probe(tester, target, size, scale);
          if (errors.isNotEmpty) {
            failures.add(
              '${target.name} @ ${size.width.toInt()}x${size.height.toInt()} '
              'scale $scale:\n  ${errors.join('\n  ')}',
            );
          }
        }
      }
    }

    if (failures.isNotEmpty) {
      fail('Layout overflows detected:\n${failures.join('\n')}');
    }
  });
}

/// Pumps [target] at [size]/[scale], scrolls it, and returns every layout
/// error that was reported.
Future<List<String>> _probe(
  WidgetTester tester,
  _Target target,
  Size size,
  double scale,
) async {
  final List<String> errors = <String>[];

  final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final String text = details.exceptionAsString();
    // Ignore non-layout noise (e.g. image decoding) but keep assertions.
    if (text.contains('overflowed') ||
        text.contains('OVERFLOW') ||
        text.contains('is not true') ||
        text.contains('infinite')) {
      errors.add('${_describe(details)}\n    ${text.split('\n').first}');
    }
  };

  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;

  try {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        builder: (BuildContext context, Widget? child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            ),
          );
        },
        home: target.screen,
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    // Scroll down through the whole screen so lazily built slivers/items are
    // laid out as well, then back to the top.
    await _scrollThrough(tester, -1);
    await _scrollThrough(tester, 1);
    await tester.pump(const Duration(milliseconds: 50));
  } finally {
    FlutterError.onError = previous;
    tester.view.reset();
  }

  return errors;
}

/// Registers a real Arabic typeface under the family name the app's Google
/// Fonts theme asks for.
///
/// Without this the widget tests fall back to the Flutter test font, whose
/// glyphs are square boxes of one em each. That makes every Arabic string
/// roughly twice as wide as it really is and produces a large number of false
/// positives. When the system font is unavailable the harness keeps the
/// default (stricter) behaviour.
Future<void> _loadArabicFont() async {
  const String family = 'NotoSansArabic';
  const List<String> candidates = <String>[
    'C:\\Windows\\Fonts\\tahoma.ttf',
    'C:\\Windows\\Fonts\\arial.ttf',
    '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
  ];
  for (final String path in candidates) {
    final File file = File(path);
    if (!file.existsSync()) continue;
    try {
      final FontLoader loader = FontLoader(family);
      loader.addFont(
        file.readAsBytes().then((List<int> bytes) {
          final ByteData data = ByteData.sublistView(Uint8List.fromList(bytes));
          return data;
        }),
      );
      await loader.load();
      return;
    } catch (_) {
      // Fall through to the next candidate.
    }
  }
  // ignore: avoid_print
  print('WARNING: no Arabic font loaded; overflow measurements are inflated.');
}

/// Builds a short description of the widget that caused the layout error.
String _describe(FlutterErrorDetails details) {
  final Iterable<DiagnosticsNode> collector =
      details.informationCollector?.call() ?? const <DiagnosticsNode>[];
  for (final DiagnosticsNode node in collector) {
    if (node is DiagnosticsProperty<Object>) {
      final Object? value = node.value;
      if (value is DebugCreator) {
        // A deep chain so the offending widget in `lib/` can be located.
        return value.element.debugGetCreatorChain(40);
      }
    }
  }
  return details.context?.toString() ?? '';
}

/// Drags every vertical scrollable of the current screen in [direction].
Future<void> _scrollThrough(WidgetTester tester, int direction) async {
  for (int i = 0; i < 16; i++) {
    final Finder vertical = find.byWidgetPredicate((Widget widget) {
      if (widget is! Scrollable) return false;
      return widget.axisDirection == AxisDirection.down;
    });
    if (vertical.evaluate().isEmpty) return;
    try {
      await tester.drag(
        vertical.first,
        Offset(0, 320.0 * direction),
        warnIfMissed: false,
      );
    } catch (_) {
      return;
    }
    await tester.pump();
  }
}
