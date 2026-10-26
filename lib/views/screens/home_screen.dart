import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/book.dart';
import '../../models/reading_plan.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/responsive.dart';
import '../widgets/widgets.dart';

/// Home screen (Screen 3): greeting, daily goal, active reading session,
/// catch-up card, community activity and recommendations.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final plan = appController.activePlan;
        final hasActivePlan = plan != null;
        final book = hasActivePlan
            ? appController.allBooks.firstWhereOrNull((b) => b.id == plan.bookId)
            : null;

        return CustomScrollView(
          slivers: [
            const _HomeAppBar(),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Greeting & daily focus
                  _GreetingCard(),
                  const SizedBox(height: 20),

                  // Active reading session
                  if (hasActivePlan && book != null)
                    _ActiveSessionCard(book: book, plan: plan)
                  else
                    _EmptyActiveSession(),
                  const SizedBox(height: 16),

                  // Recommendations
                  SectionHeader(
                    title: 'ترشيحات مخصصة',
                    subtitle: 'مختارة حسب نمط قراءتك المفضل',
                    actionLabel: 'تخصيص',
                    onAction: () {
                      Navigator.of(context).pushNamed(AppRoutes.library);
                    },
                  ),
                  const SizedBox(height: 12),
                  _RecommendationsRow(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    // The pinned header has to grow with the system text size, otherwise the
    // two-line title is clipped when the user enlarges the font.
    final double extent = _homeAppBarExtent(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AppBarDelegate(extent: extent),
    );
  }
}

/// Height of the home app bar: vertical padding + the tallest of the avatar
/// and the two-line title, measured with the current text scale.
double _homeAppBarExtent(BuildContext context) {
  const double padding = 8;
  final double title = measureTextHeight(
    context,
    'الرئيسية',
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  );
  final double subtitle = measureTextHeight(
    context,
    'نادي القراءة',
    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  );
  final double column = title + 2 + subtitle;
  return padding * 2 + maxHeightOf(<double>[40, column]);
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final double extent;

  const _AppBarDelegate({required this.extent});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BookCover(
              imageUrl: MockData.userProfile.avatarUrl,
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نادي القراءة',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'الرئيسية',
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _AppBarIcon(Icons.notifications, onTap: () {}),
              const SizedBox(width: 8),
              _AppBarIcon(Icons.search, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get minExtent => extent;
  @override
  double get maxExtent => extent;
  @override
  bool shouldRebuild(covariant _AppBarDelegate old) => old.extent != extent;
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, size: 24, color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _greetingFor(now);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$greeting، ${MockData.userProfile.name} 🌿',
                      style: const TextStyle(
                        color: Color(0xFF3E2A1E),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E4D3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCDAA85)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🔥', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Text(
                            '14 يوماً متتالياً',
                            style: TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'هدفك اليوم: قراءة 20 صفحة من كتابك الحالي',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _greetingFor(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'صباح الخير';
    if (h < 17) return 'مساء الخير';
    return 'مساء الخير';
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final Book book;
  final ReadingPlan plan;

  const _ActiveSessionCard({required this.book, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E4D3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCDAA85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories,
                  size: 20, color: Color(0xFF6B4630)),
              const SizedBox(width: 6),
              const Text(
                'جلسة القراءة النشطة',
                style: TextStyle(
                  color: Color(0xFF3E2A1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Text(
                'قراءة اليوم',
                style: TextStyle(
                  color: Color(0xFF4F5D2F),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Stack(
                children: [
                  BookCover(
                    imageUrl: book.coverUrl,
                    width: 88,
                    height: 132,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'تطوير ذات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.author,
                      style: const TextStyle(
                        color: Color(0xFF4F5D2F),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Color(0xFF3E2A1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'لماذا نعمل ما نعمل في الحياة والعمل؟',
                      style: const TextStyle(
                        color: Color(0xFF4F5D2F),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'صفحة ${plan.completedPages} من ${book.pageCount}',
                          style: const TextStyle(
                            color: Color(0xFF3E2A1E),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _ProgressPill(text: '${plan.progressPercent.toInt()}%'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: AppButton(
              text: 'تسجيل القراءة اليوم',
              type: AppButtonType.secondary,
              icon: const Icon(Icons.edit_note, size: 16),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.readingPlanProgress);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  final String text;
  const _ProgressPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4F5D2F),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyActiveSession extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      emoji: '📖',
      title: 'لا يوجد كتاب مقروء حالياً',
      description:
          'اختر كتاباً من المكتبة وابدأ خطة قراءة لتصبح جلستك النشطة هنا.',
      actionLabel: 'تصفح المكتبة',
      onAction: () {},
    );
  }
}

class _RecommendationsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = MockData.recommendedBooks;
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _BookCardCompact(book: books[i]),
      ),
    );
  }
}

class _BookCardCompact extends StatelessWidget {
  final Book book;

  const _BookCardCompact({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            BookCover(
              imageUrl: book.coverUrl,
              width: 104,
              height: 144,
              borderRadius: BorderRadius.circular(12),
            ),
            if (book.isBestseller)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'الأكثر مبيعاً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          book.title,
          style: const TextStyle(
            color: Color(0xFF3E2A1E),
            fontWeight: FontWeight.w700,
            fontSize: 13,
            height: 1.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          book.author,
          style: const TextStyle(
            color: Color(0xFF4F5D2F),
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
