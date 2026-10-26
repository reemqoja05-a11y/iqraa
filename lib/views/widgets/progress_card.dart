import 'package:flutter/material.dart';

import '../../../models/reading_plan.dart';
import '../../../theme/app_theme.dart';
import 'app_button.dart';
import 'book_cover.dart';

/// Reading progress header: book cover, title, and done/remaining counters.
class PlanHeaderCard extends StatelessWidget {
  final ReadingPlan plan;
  final String bookTitle;
  final String bookAuthor;
  final String? coverUrl;

  const PlanHeaderCard({
    super.key,
    required this.plan,
    required this.bookTitle,
    required this.bookAuthor,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            BookCover(
              imageUrl: coverUrl,
              width: 64,
              height: 88,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_stories, size: 14, color: AppColors.secondary),
                        SizedBox(width: 4),
                        Text(
                          'الخطة النشطة',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookAuthor,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondary,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${plan.completedPages}',
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'أُنجزت',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            VerticalDivider(
              color: AppColors.tertiary,
              width: 1,
              thickness: 1,
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text(
                  '${plan.pagesRemaining}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'متبقية',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Daily target + progress bar card.
class DailyTargetCard extends StatelessWidget {
  final ReadingPlan plan;
  final String todayTargetLabel;
  final int pagesLeftToday;

  const DailyTargetCard({
    super.key,
    required this.plan,
    required this.todayTargetLabel,
    required this.pagesLeftToday,
  });

  @override
  Widget build(BuildContext context) {
    final percent = plan.progressPercent.clamp(0, 100);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.flag, size: 18, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              todayTargetLabel,
                              style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${percent.toInt()}% مكتمل',
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.secondaryContainer,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.secondary),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المتبقي لليوم: $pagesLeftToday صفحة',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'إجمالي ${plan.targetPages} صفحة',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Gentle catch-up ("تدارك واستمر") card for missed reading days.
class CatchUpCard extends StatelessWidget {
  final VoidCallback onRedistribute;
  final VoidCallback onExtend;
  final VoidCallback onContinue;

  const CatchUpCard({
    super.key,
    required this.onRedistribute,
    required this.onExtend,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8EC),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE7B6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.eco, size: 24, color: Color(0xFF8A5800)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'تدارك واستمر 🌱',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE19D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'مرونة القراءة',
                              style: TextStyle(
                                color: Color(0xFF7B4B00),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'التعثر جزء طبيعي من رحلة القراءة. اختر الإجراء الأنسب لك لمتابعة خطتك بكل يسر وراحة:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondary,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'وزّع المتبقي',
                    type: AppButtonType.secondary,
                    icon: const Icon(Icons.repartition, size: 18),
                    onPressed: onRedistribute,
                    height: 44,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    text: 'مدّد الموعد',
                    type: AppButtonType.outline,
                    icon: const Icon(Icons.update, size: 18),
                    onPressed: onExtend,
                    height: 44,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'متابعة الخطة الحالية',
              type: AppButtonType.ghost,
              onPressed: onContinue,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
