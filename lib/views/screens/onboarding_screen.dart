import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Onboarding screen (Screen 1).
///
/// Introduces the app with three editorial pillars and lets the user start
/// their reading journey.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    appController.completeOnboarding();
    if (!appController.loggedIn) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar: brand + skip
              const _TopBar(),

              // Carousel of 3 slides
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _OnboardingSlide(
                      currentPage: 0,
                      title: 'اكتشف كتباً تصنع الفارق',
                      subtitle:
                          'تصفح مكتبة منتقاة بعناية تلهم فكرك وتثري معرفتك، خطوة بخطوة في بيئة مصممة للهدوء والتركيز.',
                      pillarTitle: 'مكتبة منتقاة',
                      pillarNote: 'نشط',
                      pillarDescription:
                          'ترشيحات تلائم اهتماماتك الفكرية',
                      icon: Icons.menu_book,
                    ),
                    _OnboardingSlide(
                      currentPage: 1,
                      title: 'ابنِ عادة قراءة يومية ملهمة',
                      subtitle:
                          'تتبع إنجازك بصفحات معدودة وتنبيهات رقيقة',
                      pillarTitle: 'مكتبة منتقاة',
                      pillarNote: '',
                      pillarDescription: '',
                      icon: Icons.calendar_today,
                    ),
                    _OnboardingSlide(
                      currentPage: 2,
                      title: 'اقرأ بصحبة أصدقاء واحتفل',
                      subtitle:
                          'شارك الاقتباسات والأفكار داخل أندية قراءة هادئة',
                      pillarTitle: '',
                      pillarNote: '',
                      pillarDescription: '',
                      icon: Icons.group,
                    ),
                  ],
                ),
              ),

              // Page indicator
              _PageIndicator(count: 3, current: _currentPage),

              const SizedBox(height: 24),

              // Bottom actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppButton(
                      text: _currentPage == 2 ? 'ابدأ رحلتك' : 'التالي',
                      type: AppButtonType.primary,
                      onPressed: _currentPage == 2 ? _finishOnboarding : _nextPage,
                    ),
                    const SizedBox(height: 12),
                    if (_currentPage < 2)
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: const Text(
                          'تخطي',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const Text(
            'اقرأ',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => appController.completeOnboarding(),
            child: const Text(
              'تخطي',
              style: TextStyle(
                color: Color(0xFF4F5D2F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          width: current == index ? 28 : 8,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: current == index ? AppColors.primary : AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String pillarTitle;
  final String pillarNote;
  final String pillarDescription;
  final IconData icon;
  final int currentPage;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.pillarTitle,
    required this.pillarNote,
    required this.pillarDescription,
    required this.icon,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero visual
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowTint,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'رحلة المعرفة اليومية',
                  style: TextStyle(
                    color: Color(0xFF2C1600),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department,
                      size: 18, color: AppColors.tertiary),
                  const SizedBox(width: 6),
                  const Text(
                    'أكثر من ٤٢,٠٠٠ قارئ ملتزم',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Overlapping reader avatars.
                  // The 6dp overlap is produced by explicit positions inside
                  // a Stack, because Flutter forbids a negative margin on
                  // Container. `PositionedDirectional` keeps the stack
                  // direction-aware so the RTL layout is unchanged.
                  SizedBox(
                    width: 42,
                    height: 20,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < 3; i++)
                          PositionedDirectional(
                            start: i * 14,
                            top: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: i == 0
                                    ? AppColors.primaryFixedDim
                                    : AppColors.secondaryFixedDim,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                ['س', 'م', 'ن'][i],
                                style: TextStyle(
                                  color: i == 0
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Editorial headings
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Pillar card (first one prominent, others muted)
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _pillarBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant, width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _pillarIconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 24, color: _pillarIconColor),
              ),
              title: Text(
                pillarTitle,
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: pillarDescription.isEmpty
                  ? null
                  : Text(
                      pillarDescription,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              trailing: pillarNote.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE5C2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        pillarNote,
                        style: const TextStyle(
                          color: Color(0xFF4F5D2F),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const Icon(Icons.chevron_left,
                      size: 20, color: AppColors.outline),
            ),
          ),
        ),
      ],
    );
  }

  Color get _pillarBg {
    switch (currentPage) {
      case 0:
        return AppColors.surfaceContainer;
      default:
        return AppColors.surfaceContainerLow;
    }
  }

  Color get _pillarIconBg {
    switch (currentPage) {
      case 0:
        return AppColors.primary;
      default:
        return AppColors.surfaceContainerHigh;
    }
  }

  Color get _pillarIconColor {
    switch (currentPage) {
      case 0:
        return AppColors.onPrimary;
      default:
        return AppColors.primary;
    }
  }
}
