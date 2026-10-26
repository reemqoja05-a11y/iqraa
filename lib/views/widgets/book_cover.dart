import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Book cover image with a warm placeholder fallback.
///
/// Real cover URLs come from the Stitch design assets; when the network image
/// is unavailable a neutral placeholder is shown so the UI never breaks.
class BookCover extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final bool showPlaceholderIcon;

  const BookCover({
    super.key,
    this.imageUrl,
    this.width = 80,
    this.height = 110,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.fit = BoxFit.cover,
    this.showPlaceholderIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = imageUrl != null && imageUrl!.isNotEmpty;
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: hasUrl
            ? Image.network(
                imageUrl!,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, exception, stackTrace) =>
                    _placeholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _placeholder();
                },
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.secondaryContainer,
      alignment: Alignment.center,
      child: showPlaceholderIcon
          ? const Icon(Icons.book, color: AppColors.secondary, size: 32)
          : null,
    );
  }
}
