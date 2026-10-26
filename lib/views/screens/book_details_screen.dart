import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/book.dart';
import '../../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Book Details screen (Screen 5): book metadata and the "ابدأ القراءة" CTA
/// that opens the reading plan setup bottom sheet.
class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        // The library navigates here without a specific book; show the
        // featured book from the designs (قوة العادات).
        final book = appController.allBooks.firstWhere((b) => b.id == 'b1');
        final alreadyOwned = appController.isOwned(book.id);
        final plan = appController.planForBook(book.id);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(
              slivers: [
                const _DetailsAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _BookHeader(book: book),
                      const SizedBox(height: 16),
                      _MetaBadges(book: book),
                      const SizedBox(height: 20),
                      _Excerpt(book: book),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: AppButton(
                          text: alreadyOwned && plan != null
                              ? 'استكمال خطة القراءة'
                              : 'ابدأ القراءة',
                          type: AppButtonType.primary,
                          icon: const Icon(Icons.menu_book, size: 20),
                          onPressed: () =>
                              _openPlanSetupSheet(context, book),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPlanSetupSheet(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlanSetupSheet(book: book),
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  const _DetailsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _DetailsAppBarDelegate(),
    );
  }
}

class _DetailsAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface.withValues(alpha: 0.94),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward, // RTL back
                  size: 24,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'تفاصيل الكتاب',
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _ActionIcon(Icons.bookmark_add, onTap: () {}),
          const SizedBox(width: 8),
          _ActionIcon(Icons.share, onTap: () {}),
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

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon(this.icon, {required this.onTap});

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

class _BookHeader extends StatelessWidget {
  final Book book;

  const _BookHeader({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            BookCover(
              imageUrl: book.coverUrl,
              width: 132,
              height: 212,
              borderRadius: BorderRadius.circular(16),
            ),
            if (book.isBestseller)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'الأكثر مبيعاً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          book.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          book.author,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MetaBadges extends StatelessWidget {
  final Book book;

  const _MetaBadges({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Chip(
              text: book.category,
              color: AppColors.surfaceContainerLow,
              textColor: AppColors.secondary,
            ),
            const SizedBox(width: 6),
            Text('•', style: TextStyle(color: AppColors.outlineVariant)),
            const SizedBox(width: 6),
            _Chip(
              text: '${book.rating.toStringAsFixed(1)} ⭐',
              color: AppColors.surfaceContainerLow,
              textColor: AppColors.secondary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _StatItem(label: 'الصفحات', value: '${book.pageCount} صفحة', color: AppColors.primary)),
            Expanded(child: _StatItem(label: 'التقييم', value: '${book.rating.toStringAsFixed(1)} (${book.ratingCount})', color: AppColors.primary)),
            Expanded(child: _StatItem(label: 'متوسط القراءة', value: '14 يوماً', color: AppColors.tertiary)),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Chip({required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Excerpt extends StatelessWidget {
  final Book book;

  const _Excerpt({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نبذة عن الكتاب',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.summary ??
              'لا يوجد ملخص متاح لهذا الكتاب.',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
            height: 1.7,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Reading plan setup bottom sheet (Screen 5 modal).
class _PlanSetupSheet extends StatefulWidget {
  final Book book;

  const _PlanSetupSheet({super.key, required this.book});

  @override
  State<_PlanSetupSheet> createState() => _PlanSetupSheetState();
}

class _PlanSetupSheetState extends State<_PlanSetupSheet> {
  int _selectedDays = 14; // 14, 21, 30 or -1 for custom
  DateTime? _customDate;
  bool _reminderEnabled = true;
  String _reminderTime = '08:30 م';

  int get _days {
    if (_selectedDays == -1 && _customDate != null) {
      return DateTime.now().difference(_customDate!).inDays.abs().clamp(1, 365);
    }
    return _selectedDays;
  }

  int get _dailyTarget {
    return ((widget.book.pageCount / _days)).ceil();
  }

  String get _finishDateLabel {
    final target = _selectedDays == -1 && _customDate != null
        ? _customDate!
        : DateTime.now().add(Duration(days: _days));
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return 'تاريخ الختم المتوقع: ${target.day} ${months[target.month - 1]} ${target.year}';
  }

  void _selectDuration(int days) {
    setState(() {
      _selectedDays = days;
      _customDate = null;
    });
  }

  Future<void> _pickCustomDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _selectedDays = -1;
        _customDate = picked;
      });
    }
  }

  Future<void> _confirm() async {
    final targetDate = _selectedDays == -1 && _customDate != null
        ? _customDate!
        : DateTime.now().add(Duration(days: _days));

    appController.createReadingPlan(
      bookId: widget.book.id,
      targetDate: targetDate,
      targetPages: widget.book.pageCount,
      reminderTime: _reminderTime,
      remindersEnabled: _reminderEnabled,
    );

    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.book.pageCount;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) => ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              const Center(
                child: SizedBox(
                  width: 48,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFCDAA85),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text('تخصيص خطتك القرائية',
                            style: TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(width: 8),
                        const Text('📖', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'اختر المدة التي تناسب جدولك وسنتكفل بحساب الأهداف لك.',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),

              // Book summary card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EE),
                  border: Border.all(color: const Color(0xFFCDAA85).withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    BookCover(
                      imageUrl: widget.book.coverUrl,
                      width: 44,
                      height: 64,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.title,
                            style: const TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'إجمالي الصفحات: $totalPages صفحة • ${widget.book.author}',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E4D3),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.menu_book, size: 20, color: Color(0xFF6B4630)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Duration selector
              const Text(
                'مدة القراءة المستهدفة:',
                style: TextStyle(
                  color: Color(0xFF3E2A1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _DurationChip(
                    label: '14 يوماً (أسبوعان)',
                    value: 14,
                    selected: _selectedDays == 14,
                    recommended: true,
                    onTap: () => _selectDuration(14),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _DurationChip(
                    label: '21 يوماً (3 أسابيع)',
                    value: 21,
                    selected: _selectedDays == 21,
                    onTap: () => _selectDuration(21),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _DurationChip(
                    label: '30 يوماً (شهر)',
                    value: 30,
                    selected: _selectedDays == 30,
                    onTap: () => _selectDuration(30),
                  ))],
              ),
              const SizedBox(width: 0),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: _pickCustomDate,
                  icon: const Icon(Icons.calendar_month, size: 20, color: Color(0xFF4F5D2F)),
                  label: const Text(
                    'تاريخ مخصص',
                    style: TextStyle(
                      color: Color(0xFF3E2A1E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCDAA85), width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFFFBF6EE),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Daily rate card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EE),
                  border: Border.all(color: const Color(0xFFCDAA85)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المعدل اليومي المطلوب',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '$_dailyTarget',
                                    style: const TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Text(
                                    ' صفحة / يومياً',
                                    style: TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(≈ ${_dailyTarget * 25 / 60} دقيقة)',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1E4D3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.timer, size: 24, color: Color(0xFF6B4630)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFFCDAA85), height: 1),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.event_available,
                            size: 18, color: Color(0xFF4F5D2F)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color(0xFF3E2A1E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                const TextSpan(text: 'تاريخ الختم المتوقع: '),
                                TextSpan(
                                  text: _finishDateLabel.split(': ').last,
                                  style: const TextStyle(
                                    color: Color(0xFF3E2A1E),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Daily reminder toggle
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EE),
                  border: Border.all(color: const Color(0xFFCDAA85)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E4D3),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.notifications_active,
                          size: 20, color: Color(0xFF6B4630)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تذكير يومي بالقراءة',
                            style: TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'الموعد المحدد:',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1E4D3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_reminderTime,
                                        style: const TextStyle(
                                          color: Color(0xFF3E2A1E),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.edit, size: 14, color: Color(0xFF4F5D2F)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                      scale: 0.85,
                      child: Checkbox(
                        value: _reminderEnabled,
                        onChanged: (v) => setState(() => _reminderEnabled = v ?? false),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Action buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: AppButton(
                  text: 'تأكيد وبدء الخطة القرائية',
                  type: AppButtonType.primary,
                  icon: const Icon(Icons.checklist_rtl, size: 20),
                  onPressed: _confirm,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: AppButton(
                  text: 'إلغاء',
                  type: AppButtonType.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final int value;
  final bool selected;
  final bool recommended;
  final VoidCallback onTap;

  const _DurationChip({
    required this.label,
    required this.value,
    required this.selected,
    this.recommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1E4D3) : const Color(0xFFFBF6EE),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFCDAA85),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: selected ? AppColors.primary : const Color(0xFFCDAA85),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? const Color(0xFF3E2A1E) : const Color(0xFF4F5D2F),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (recommended && selected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFCDAA85).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'الموصى به',
                  style: TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
