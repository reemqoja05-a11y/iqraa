// Regression test for the negative-margin Container assertion.
//
// The overlapping avatar rows on the onboarding and groups screens used to use
// `margin: EdgeInsets.only(left: -6)`, which trips
// `assert(margin == null || margin.isNonNegative)` in Flutter's Container.
// The 6dp overlap is now produced with a Stack + PositionedDirectional, so this
// test pins down that both screens still render and that the overlap is intact.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iqraa/main.dart';
import 'package:iqraa/views/screens/groups_screen.dart';

/// A realistic desktop window size.
///
/// Note: the onboarding hero column overflows by a few pixels on short
/// windows (800x600 / 1280x720) — a pre-existing layout issue that is
/// unrelated to the negative margin and is not part of this regression test.
const Size _desktopSize = Size(1280, 900);

void main() {
  void useDesktopSurface(WidgetTester tester) {
    tester.view.physicalSize = _desktopSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  /// Returns the rectangles of the avatars inside [stack], ordered from the
  /// leading edge (right, in the RTL layout) to the trailing edge.
  List<Rect> avatarRects(WidgetTester tester, Finder stack) {
    final containers = find.descendant(of: stack, matching: find.byType(Container));
    final rects = <Rect>[];
    for (final widget in tester.widgetList<Container>(containers)) {
      rects.add(tester.getRect(find.byWidget(widget)));
    }
    rects.sort((a, b) => b.left.compareTo(a.left));
    return rects;
  }

  testWidgets('onboarding renders overlapping reader avatars', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(const IqraApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    final stack = find.byWidgetPredicate(
      (w) => w is Stack && w.clipBehavior == Clip.none,
    );
    expect(stack, findsOneWidget);

    final rects = avatarRects(tester, stack);
    expect(rects.length, 3);

    // Each avatar overlaps the previous one by 6dp and stays on one line.
    for (var i = 1; i < rects.length; i++) {
      expect(rects[i].right - rects[i - 1].left, closeTo(6, 0.01));
      expect(rects[i].top, closeTo(rects[i - 1].top, 0.01));
      expect(rects[i].bottom, closeTo(rects[i - 1].bottom, 0.01));
    }
  });

  testWidgets('groups renders overlapping member avatars', (tester) async {
    useDesktopSurface(tester);

    await tester.pumpWidget(
      const MaterialApp(
        home: GroupsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    final stack = find.byWidgetPredicate(
      (w) => w is Stack && w.clipBehavior == Clip.none,
    );
    expect(stack, findsOneWidget);

    final rects = avatarRects(tester, stack);
    expect(rects.length, 3); // two members + the "+15" counter

    for (var i = 1; i < rects.length; i++) {
      expect(rects[i].right - rects[i - 1].left, closeTo(6, 0.01));
      expect(rects[i].top, closeTo(rects[i - 1].top, 0.01));
      expect(rects[i].bottom, closeTo(rects[i - 1].bottom, 0.01));
    }
  });
}
