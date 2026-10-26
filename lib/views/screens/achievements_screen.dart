import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Achievements screen (Screen 10): reading stats, badges, certificate and
/// commitment leaderboard. Settings is reachable from the top bar.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final achievements = appController.achievements;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.emoji_events,
                        size: 20, color: Color(0xFFFBF6EE)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'إنجازاتي',
                    style: TextStyle(
                      color: Color(0xFF3E2A1E),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              actions: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(Icons.settings,
                          size: 22, color: Color(0xFF4F5D2F)),
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                // Block 1: Streak & consistency summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E4D3),
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
                                  'التتابع القرائي والالتزام',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      '14',
                                      style: TextStyle(
                                        color: Color(0xFF3E2A1E),
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'يوماً متتالياً 🔥',
                                      style: TextStyle(
                                        color: Color(0xFF6B4630),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'أطول تتابع: 42 يوماً • نسبة الالتزام 96%',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.local_fire_department,
                                size: 28, color: Color(0xFFFBF6EE)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(color: Color(0xFFCDAA85), height: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _StatColumn(value: '12', label: 'كتب مكتملة'),
                          const VerticalDivider(
                              color: Color(0xFFCDAA85), width: 1, thickness: 1),
                          _StatColumn(value: '3,450', label: 'صفحة مقروءة'),
                          const VerticalDivider(
                              color: Color(0xFFCDAA85), width: 1, thickness: 1),
                          _StatColumn(
                              value: 'المستوى 4',
                              label: 'قارئ متمرس',
                              valueColor: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Block 2: Key badges grid
                const Text(
                  'الأوسمة الرئيسية',
                  style: TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '3 أوسمة بارزة',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _badgeCard(
                      icon: Icons.import_contacts,
                      iconColor: const Color(0xFF9A6B48),
                      title: 'أول كتاب',
                      subtitle: 'مكتمل 📖',
                      unlocked: achievements.isNotEmpty ? achievements[0].unlocked : false,
                    )),
                    Expanded(child: _badgeCard(
                      icon: Icons.library_books,
                      iconColor: AppColors.primary,
                      title: '5 كتب',
                      subtitle: 'مكتمل 📚',
                      unlocked: achievements.length > 1 ? achievements[1].unlocked : false,
                    )),
                    Expanded(child: _badgeCard(
                      icon: Icons.local_fire_department,
                      iconColor: const Color(0xFF4F5D2F),
                      title: 'عدتُ وأكملت',
                      subtitle: 'مكتمل 🌱',
                      unlocked: achievements.length > 2 ? achievements[2].unlocked : false,
                    )),
                  ],
                ),
                const SizedBox(height: 16),

                // Block 3: Book completion certificate
                const Text(
                  'شهادة الختم',
                  style: TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ختم موثّق',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.workspace_premium,
                                  size: 20, color: Color(0xFFFBF6EE)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F5D2F)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'موثّقة رسمياً',
                                style: TextStyle(
                                  color: Color(0xFF4F5D2F),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'شهادة إتمام قراءة كتاب',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'قوة العادات',
                          style: const TextStyle(
                            color: Color(0xFF3E2A1E),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'تشارلز دوهيج • أنهيته في 14 يوماً',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'تاريخ الختام\n18 مارس 2024',
                                style: const TextStyle(
                                  color: Color(0xFF3E2A1E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Icon(Icons.verified,
                                size: 24, color: Color(0xFF9A6B48)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 34,
                                child: AppButton(
                                  text: 'مشاركة الشهادة',
                                  icon: const Icon(Icons.share, size: 16),
                                  type: AppButtonType.secondary,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 70,
                              height: 34,
                              child: AppButton(
                                text: 'معاينة',
                                type: AppButtonType.ghost,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Block 4: Commitment honor row
                const Text(
                  'لوحة الالتزام',
                  style: TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'أنتِ بالمرتبة الثانية ⭐',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Color(0xFFFBF6EE),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BookCover(
                            imageUrl: MockData.userProfile.avatarUrl,
                            width: 34,
                            height: 34,
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'سارة اليافعي',
                                    style: TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9A6B48),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'أنتِ',
                                      style: TextStyle(
                                        color: Color(0xFFFBF6EE),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '14 يوماً متواصلاً • 620 صفحة',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F5D2F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '96% التزام',
                            style: TextStyle(
                              color: Color(0xFFFBF6EE),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const _StatColumn({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _badgeCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required bool unlocked,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: unlocked ? const Color(0xFFF1E4D3) : AppColors.surfaceContainerLow,
      border: Border.all(color: const Color(0xFFCDAA85)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: unlocked ? iconColor : AppColors.outlineVariant,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20,
              color: unlocked ? Colors.white : AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: unlocked ? const Color(0xFF3E2A1E) : AppColors.outlineVariant,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            color: unlocked ? const Color(0xFF4F5D2F) : AppColors.outlineVariant,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
