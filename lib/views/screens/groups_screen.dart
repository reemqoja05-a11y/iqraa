import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Reading Groups screen (Screen 7): my groups and public challenges,
/// plus the primary "create group or challenge" action.
class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  bool _myGroups = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final groups = appController.groups;
        final myGroups = groups.where((g) => !g.isChallenge).toList();
        final challenges = groups.where((g) => g.isChallenge).toList();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('مجموعات وتحديات القراءة'),
              centerTitle: false,
              actions: [
                _NavIcon(Icons.search, onTap: () {}),
                const SizedBox(width: 8),
                _NavIcon(Icons.group_add, onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.createGroup);
                }),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: double.infinity,
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppButton(
                  text: 'إنشاء مجموعة أو تحدي +',
                  type: AppButtonType.primary,
                  icon: const Icon(Icons.add_circle, size: 22),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.createGroup);
                  },
                ),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                // Tabs
                Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'مجموعاتي',
                        icon: Icons.groups,
                        active: _myGroups,
                        count: myGroups.length,
                        onTap: () => setState(() => _myGroups = true),
                      ),
                    ),
                    Expanded(
                      child: _TabButton(
                        label: 'تحديات عامة',
                        icon: Icons.explore,
                        active: !_myGroups,
                        onTap: () => setState(() => _myGroups = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Active groups section
                if (_myGroups) ...[
                  const SectionHeader(
                    title: 'المجموعات النشطة',
                    subtitle: 'اليوم',
                  ),
                  const SizedBox(height: 10),
                  ...myGroups.map((g) => _GroupCard(group: g)).toList(),
                  const SizedBox(height: 20),
                ],

                // Active challenges section
                if (!_myGroups) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'التحديات الجارية',
                        style: TextStyle(
                          color: Color(0xFF3E2A1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'عرض التحديات',
                          style: TextStyle(
                            color: Color(0xFF6B4630),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...challenges.map((g) => _ChallengeCard(group: g)).toList(),
                  const SizedBox(height: 20),
                ],

                if (groups.isEmpty)
                  const Center(
                    child: Text('لا توجد مجموعات أو تحديات متاحة حالياً.'),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, size: 24, color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final int? count;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.active,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: active ? AppColors.primary : AppColors.secondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? const Color(0xFF3E2A1E) : AppColors.secondary,
                fontSize: 14,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5BF8E).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Color(0xFF4F5D2F),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final dynamic group; // ReadingGroup

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                BookCover(
                  imageUrl: group.bookCoverUrl,
                  width: 64,
                  height: 90,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB5BF8E).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4F5D2F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'نشط الآن',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'باب العمران',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Color(0xFF3E2A1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'الكتاب: ',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            group.bookTitle,
                            style: const TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.group, size: 16, color: Color(0xFF7A8A4B)),
                          const SizedBox(width: 4),
                          Text(
                            '${group.memberCount} قارئاً ملتزماً',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openDetails(context, group.id),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Icon(Icons.more_vert,
                          size: 20, color: Color(0xFF4F5D2F)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6EE),
                border: Border.all(color: const Color(0xFFCDAA85).withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up,
                              size: 16, color: Color(0xFF6B4630)),
                          const SizedBox(width: 4),
                          Text(
                            'تقدم القراءة الجماعي',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${group.collectiveProgress.toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF6B4630),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: group.collectiveProgress / 100,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE8DFC8),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF6B4630)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Overlapping member avatars plus the "+15" counter.
                      // The 6dp overlap is produced by explicit positions
                      // inside a Stack, because Flutter forbids a negative
                      // margin on Container. `PositionedDirectional` keeps the
                      // stack direction-aware so the RTL layout is unchanged.
                      SizedBox(
                        width: 60,
                        height: 24,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = 0; i < 2; i++)
                              PositionedDirectional(
                                start: i * 18,
                                top: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5E2E0),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'ق',
                                    style: TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            PositionedDirectional(
                              start: 36,
                              top: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E2E0),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '+15',
                                  style: TextStyle(
                                    color: Color(0xFF3E2A1E),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'يناقشون الآن',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openDetails(context, group.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB5BF8E).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'غرفة الحوار',
                                  style: TextStyle(
                                    color: Color(0xFF4F5D2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.forum, size: 16, color: Color(0xFF4F5D2F)),
                              ],
                            ),
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
      ),
    );
  }

  void _openDetails(BuildContext context, String id) {
    Navigator.of(context).pushNamed(AppRoutes.groupDetails);
  }
}

class _ChallengeCard extends StatelessWidget {
  final dynamic group;

  const _ChallengeCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                BookCover(
                  imageUrl: group.bookCoverUrl,
                  width: 64,
                  height: 90,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCDAA85).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.local_fire_department,
                                    size: 12, color: Color(0xFF6B4630)),
                                const SizedBox(width: 4),
                                Text(
                                  'تحدٍ مستمر',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '14/21 يوم',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Color(0xFF3E2A1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'الكتاب: ',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            group.bookTitle,
                            style: const TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.group, size: 16, color: Color(0xFF7A8A4B)),
                          const SizedBox(width: 4),
                          Text(
                            '${group.memberCount} قارئاً ملتزماً',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openDetails(context, group.id),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Icon(Icons.more_vert,
                          size: 20, color: Color(0xFF4F5D2F)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6EE),
                border: Border.all(color: const Color(0xFFCDAA85).withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event,
                              size: 16, color: Color(0xFF6B4630)),
                          const SizedBox(width: 4),
                          Text(
                            'إنجاز التحدي',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${group.collectiveProgress.toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF4F5D2F),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: group.collectiveProgress / 100,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE8DFC8),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF4F5D2F)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF6EE),
                          border: Border.all(color: const Color(0xFFCDAA85).withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event,
                                size: 16, color: Color(0xFF6B4630)),
                            const SizedBox(width: 4),
                            Text(
                              'اللقاء: الجمعة 8:00 م',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        child: AppButton(
                          text: 'تسجيل الحضور',
                          type: AppButtonType.primary,
                          icon: const Icon(Icons.how_to_reg, size: 16),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, String id) {
    Navigator.of(context).pushNamed(AppRoutes.groupDetails);
  }
}


