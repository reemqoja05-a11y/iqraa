import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Responsive measurement helpers shared by the screens.
///
/// The app is used with the system accessibility font size, so every piece of
/// chrome that has a fixed height (toolbars, chip rows, carousels) has to be
/// able to grow with the text instead of clipping it. These helpers measure
/// the real laid-out size of a piece of text so the surrounding boxes can be
/// sized from the content rather than from a hard-coded pixel value.

/// Measures the height of [text] rendered with [style].
///
/// The ambient [TextScaler] of [context] is honoured, so the result grows
/// with the user's font-size preference. When [maxWidth] is finite the text
/// is wrapped exactly like a [Text] widget would wrap it, and [maxLines]
/// limits the number of lines the same way [Text.maxLines] does.
double measureTextHeight(
  BuildContext context,
  String text,
  TextStyle style, {
  double maxWidth = double.infinity,
  int? maxLines,
}) {
  final TextPainter painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
    maxLines: maxLines,
    ellipsis: maxLines != null ? '\u2026' : null,
  )..layout(maxWidth: maxWidth);
  final double height = painter.height;
  painter.dispose();
  return height;
}

/// The largest of the given heights, used to size a box around its tallest
/// child.
double maxHeightOf(Iterable<double> heights) {
  double result = 0;
  for (final double height in heights) {
    result = math.max(result, height);
  }
  return result;
}
