import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/book.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Library screen (Screen 4): browse catalog, search, filter by category,
/// add books to the personal library and mark favorites.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        return CustomScrollView(
          slivers: [
            const _LibraryAppBar(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Search bar
                  _SearchBar(),
                  const SizedBox(height: 16),

                  // Category filter chips
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: BookCategory.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final category = BookCategory.values[i];
                        return CategoryChip(
                          category: category,
                          selected: appController.selectedCategory == category,
                          onTap: () =>
                              appController.selectCategory(category),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Featured book spotlight
                  SectionHeader(
                    title: 'الكتب المميزة',
                    actionLabel: 'عرض الكل',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  _FeaturedCard(),
                  const SizedBox(height: 20),

                  // Recommendations grid
                  SectionHeader(
                    title: 'ترشيحات تلائم جدولك',
                    subtitle: 'مختارة حسب نمط قراءتك المفضل',
                    actionLabel: 'تخصيص',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  _RecommendationsGrid(),
                  const SizedBox(height: 16),

                  // Popular this week
                  SectionHeader(
                    title: 'الأكثر قراءة هذا الأسبوع',
                    subtitle: 'تحديث مستمر',
                  ),
                  const SizedBox(height: 12),
                  _PopularList(),
                  const SizedBox(height: 100), // bottom nav clearance
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LibraryAppBar extends StatelessWidget {
  const _LibraryAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AppBarDelegate(),
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.95),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          _AppBarIcon(Icons.tune, label: 'تصفية المحتوى', onTap: () {}),
          const Spacer(),
          Text(
            'المكتبة',
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _AppBarIcon(Icons.bookmark, label: 'قائمتي المحفوظة', onTap: () {}),
        ],
      ),
    );
  }

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => false;
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AppBarIcon(this.icon, {required this.label, required this.onTap});

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

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return TextField(
      controller: controller,
      onChanged: (v) => appController.updateSearch(v),
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Color(0xFF3E2A1E), fontSize: 14),
      decoration: InputDecoration(
        hintText: 'ابحث عن كتاب، كاتب، أو موضوع...',
        hintStyle: TextStyle(
          color: AppColors.secondary.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        prefixIcon: const Icon(Icons.search, size: 22, color: Color(0xFF4F5D2F)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.mic, size: 20, color: Color(0xFF4F5D2F)),
          onPressed: () {},
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFCDAA85)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFCDAA85)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        isDense: true,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final book = appController.allBooks.firstWhere((b) => b.id == 'b2');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCDAA85)),
      ),
      child: Row(
        children: [
          BookCover(
            imageUrl: book.coverUrl,
            width: 88,
            height: 112,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: const TextStyle(
                    color: Color(0xFF4F5D2F),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: AppButton(
                    text: 'إضافة للجدول',
                    type: AppButtonType.primary,
                    icon: const Icon(Icons.bookmark_add, size: 16),
                    onPressed: () {
                      appController.addToLibrary(book);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = appController.filteredBooks.take(8).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: books.length,
      itemBuilder: (_, i) => _BookGridCard(book: books[i]),
    );
  }
}

class _BookGridCard extends StatelessWidget {
  final Book book;

  const _BookGridCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final owned = appController.isOwned(book.id);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.bookDetails);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              BookCover(
                imageUrl: book.coverUrl,
                width: double.infinity,
                height: 132,
                borderRadius: BorderRadius.circular(16),
              ),
              if (owned)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
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
              fontSize: 12,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: const TextStyle(
              color: Color(0xFF4F5D2F),
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PopularList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = appController.allBooks.skip(2).take(4).toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final book = books[i];
        final rank = i + 1;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCDAA85)),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank == 1 ? AppColors.primary : const Color(0xFF4F5D2F),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank == 1 ? '١' : rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BookCover(
                imageUrl: book.coverUrl,
                width: 44,
                height: 60,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        color: Color(0xFF3E2A1E),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
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
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  appController.isFavorite(book.id)
                      ? Icons.bookmark
                      : Icons.bookmark_add,
                  color: appController.isFavorite(book.id)
                      ? AppColors.primary
                      : AppColors.secondary,
                  size: 20,
                ),
                onPressed: () => appController.toggleFavorite(book.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
