import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iqraa/theme/app_theme.dart';
import 'package:iqraa/views/screens/groups_screen.dart';

void main() {
  testWidgets('dump overflow details', (WidgetTester tester) async {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) {
        final Iterable<DiagnosticsNode> collector =
            details.informationCollector?.call() ?? const <DiagnosticsNode>[];
        for (final DiagnosticsNode node in collector) {
          if (node is DiagnosticsProperty<Object>) {
            // ignore: avoid_print
            print('CHAIN: ${node.value}');
          }
        }
        // ignore: avoid_print
        print('EXC: ${details.exceptionAsString()}');
      }
    };

    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(360, 640);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        builder: (BuildContext context, Widget? child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        ),
        home: const GroupsScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    FlutterError.onError = previous;
  });
}
