import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/book.dart';
import '../../models/reading_plan.dart';
import '../../theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Reading Plan & Progress screen (Screen 6).
///
/// Shows today's reading target, progress, quick page entry and the
/// restorative "تدارك واستمر" catch-up options for missed days.
class ReadingPlanProgressScreen extends StatefulWidget {
  const ReadingPlanProgressScreen({super.key});

  @override
  State<ReadingPlanProgressScreen> createState() =>
      _ReadingPlanProgressScreenState();
}

class _ReadingPlanProgressScreenState extends State<ReadingPlanProgressScreen> {
  final _pageController = TextEditingController();

  ReadingPlan? get _plan => appController.activePlan;
  Book? get _book {
    final plan = _plan;
    if (plan == null) return null;
    return appController.allBooks.firstWhereOrNull((b) => b.id == plan.bookId);
  }

  bool get _hasMissedDay {
    final plan = _plan;
    if (plan == null || plan.isCompleted) return false;
    final last = plan.lastCompletedDate;
    if (last == null) return false;
    final now = DateTime.now();
    return !(last.year == now.year &&
        last.month == now.month &&
        last.day == now.day);
  }

  int get _pagesLeftToday {
    final plan = _plan;
    if (plan == null) return 0;
    return plan.dailyTarget;
  }

  @override
  void initState() {
    super.initState();
    final plan = _plan;
    _pageController.text = plan != null ? plan.completedPages.toString() : '0';
  }

  void _addQuickPages(int amount) {
    final plan = _plan;
    if (plan == null) return;
    final current = int.tryParse(_pageController.text) ?? plan.completedPages;
    final next = (current + amount).clamp(0, plan.targetPages);
    setState(() => _pageController.text = next.toString());
  }

  Future<void> _saveProgress() async {
    final plan = _plan;
    if (plan == null) return;

    final target = int.tryParse(_pageController.text) ?? plan.completedPages;
    final delta = target - plan.completedPages;

    if (delta <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('لم يتم إدخال صفحات جديدة اليوم'),
          backgroundColor: Color(0xFF6B4630),
        ));
      }
      return;
    }

    final saved = appController.recordProgress(plan.id, delta);
    if (!mounted) return;

    if (saved) {
      if (plan.isCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('أكملت الكتاب بنجاح! 🎉'),
          backgroundColor: Color(0xFF4F5D2F),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('تم حفظ إنجاز اليوم بنجاح'),
          backgroundColor: Color(0xFF6B4630),
        ));
      }
      _pageController.text = plan.completedPages.toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('لقد سجلت قراءتك اليوم بالفعل'),
        backgroundColor: Color(0xFF6B4630),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final plan = _plan;
        final book = _book;
        if (plan == null || book == null) {
          return const Scaffold(
            body: Center(child: Text('لا توجد خطة قراءة نشطة')),
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                // Header card
                Card(
                  color: const Color(0xFFF1E4D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFFCDAA85)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                BookCover(
                                  imageUrl: book.coverUrl,
                                  width: 68,
                                  height: 96,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '65%',
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.auto_stories,
                                            size: 14, color: Color(0xFF4F5D2F)),
                                        SizedBox(width: 4),
                                        Text(
                                          'الخطة النشطة',
                                          style: TextStyle(
                                            color: Color(0xFF4F5D2F),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
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
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${plan.completedPages}',
                                  style: const TextStyle(
                                    color: Color(0xFF3E2A1E),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'أُنجزت',
                                  style: TextStyle(
                                    color: Color(0xFF4F5D2F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const VerticalDivider(
                              color: Color(0xFFCDAA85),
                              width: 1,
                              thickness: 1,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                Text(
                                  '${plan.pagesRemaining}',
                                  style: const TextStyle(
                                    color: Color(0xFF6B4630),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'متبقية',
                                  style: TextStyle(
                                    color: Color(0xFF4F5D2F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Daily target & progress bar
                Card(
                  color: const Color(0xFFFAF5EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flag,
                                size: 18, color: Color(0xFF4F5D2F)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'ورد القراءة اليوم: ص ${plan.completedPages + 1} حتى ${(plan.completedPages + _pagesLeftToday).clamp(0, book.pageCount)}',
                                          style: const TextStyle(
                                            color: Color(0xFF3E2A1E),
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
                                          '${plan.progressPercent.toInt()}% مكتمل',
                                          style: const TextStyle(
                                            color: Color(0xFF4F5D2F),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: plan.progressPercent / 100,
                            minHeight: 6,
                            backgroundColor: AppColors.secondaryContainer,
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xFF7A8A4B)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المتبقي لليوم: $_pagesLeftToday صفحة',
                              style: const TextStyle(
                                color: Color(0xFF4F5D2F),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'إجمالي ${book.pageCount} صفحة',
                              style: const TextStyle(
                                color: Color(0xFF4F5D2F),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Catch-up card for missed days
                if (_hasMissedDay)
                  CatchUpCard(
                    onRedistribute: () {
                      appController.handleMissedDay(plan.id, redistribute: true);
                    },
                    onExtend: () {
                      appController.handleMissedDay(plan.id, extend: true);
                    },
                    onContinue: () {
                      appController.handleMissedDay(plan.id);
                    },
                  ),
                if (_hasMissedDay) const SizedBox(height: 16),

                // Quick progress entry
                Card(
                  color: const Color(0xFFF1E4D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFFCDAA85)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.edit_note,
                                size: 22, color: Color(0xFF4F5D2F)),
                            const SizedBox(width: 8),
                            const Text(
                              'تسجيل قراءة اليوم',
                              style: TextStyle(
                                color: Color(0xFF3E2A1E),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'آخر مسجل: ص ${plan.completedPages}',
                              style: const TextStyle(
                                color: Color(0xFF4F5D2F),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Text(
                              'إضافة سريعة:',
                              style: TextStyle(
                                color: Color(0xFF4F5D2F),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _QuickChip(label: '+5 ص', amount: 5),
                            const SizedBox(width: 8),
                            _QuickChip(label: '+10 ص', amount: 10),
                            const SizedBox(width: 8),
                            _QuickChip(label: '+20 ص', amount: 20),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _pageController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Color(0xFF3E2A1E),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            hintText: 'وصلت إلى صفحة...',
                            hintStyle: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAF5EE),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFCDAA85)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFCDAA85)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                            suffixText: 'رقم الصفحة',
                            suffixStyle: const TextStyle(
                              color: Color(0xFF4F5D2F),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: AppButton(
                            text: 'حفظ الإنجاز وتحديث الخطة ✓',
                            type: AppButtonType.primary,
                            icon: const Icon(Icons.check_circle, size: 22),
                            onPressed: _saveProgress,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final int amount;

  const _QuickChip({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final state = context.findAncestorStateOfType<
            _ReadingPlanProgressScreenState>();
        state?._addQuickPages(amount);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EBD3),
          border: Border.all(color: const Color(0xFFCDAA85)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4F5D2F),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
