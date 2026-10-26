import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Settings and Profile screen (Screen 11): user profile, reading
/// preferences, personalization and account actions.
class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  bool _reminderNotifications = true;
  bool _groupNotifications = true;
  String _selectedLanguage = 'ar';
  String _selectedTheme = 'light';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_forward,
                        size: 24, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
              title: const Text('الإعدادات'),
              actions: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                // Block 1: Profile card
                _ProfileCard(),
                const SizedBox(height: 16),

                // Block 2: Reading preferences & notifications
                _SectionTitle(
                  icon: Icons.notifications_active,
                  title: 'تفضيلات القراءة والتنبيهات',
                ),
                const SizedBox(height: 8),
                _PreferencesCard(
                  children: [
                    _ListTile(
                      icon: Icons.schedule,
                      title: 'وقت التذكير بالورد اليومي',
                      subtitle: 'كل يوم في تمام 08:30 مساءً',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '08:30 م',
                          style: TextStyle(
                            color: Color(0xFF4F5D2F),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      trailingIcon: Icons.chevron_left,
                      trailingIconColor: AppColors.secondary,
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _SwitchTile(
                      icon: Icons.alarm_on,
                      title: 'إشعارات تذكير القراءة',
                      subtitle: 'تنبيه لطيف لمواصلة سلسلتك',
                      value: _reminderNotifications,
                      onChanged: (v) => setState(() => _reminderNotifications = v ?? false),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _SwitchTile(
                      icon: Icons.groups,
                      title: 'تنبيهات مجموعات القراءة',
                      subtitle: 'نقاشات وتوصيات أصدقائك',
                      value: _groupNotifications,
                      onChanged: (v) => setState(() => _groupNotifications = v ?? false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Block 3: Personalization
                _SectionTitle(
                  icon: Icons.palette,
                  title: 'التخصيص والمظهر',
                ),
                const SizedBox(height: 8),
                _PreferencesCard(
                  children: [
                    _SegmentedTile(
                      icon: Icons.translate,
                      title: 'لغة التطبيق',
                      subtitle: 'العربية',
                      options: const [
                        SegmentOption(label: 'العربية', value: 'ar'),
                        SegmentOption(label: 'English', value: 'en'),
                      ],
                      selectedValue: _selectedLanguage,
                      onChanged: (v) {
                        setState(() => _selectedLanguage = v!);
                        appController.setLocale(v == 'ar'
                            ? const Locale('ar')
                            : const Locale('en'));
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _SegmentedTile(
                      icon: Icons.light_mode,
                      title: 'المظهر',
                      subtitle: 'فاتح هادئ',
                      options: const [
                        SegmentOption(label: 'فاتح', value: 'light'),
                        SegmentOption(label: 'داكن', value: 'dark'),
                        SegmentOption(label: 'تلقائي', value: 'system'),
                      ],
                      selectedValue: _selectedTheme,
                      onChanged: (v) {
                        setState(() => _selectedTheme = v!);
                        switch (v) {
                          case 'light':
                            appController.setThemeMode(ThemeMode.light);
                          case 'dark':
                            appController.setThemeMode(ThemeMode.dark);
                          case 'system':
                            appController.setThemeMode(ThemeMode.system);
                        }
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _ListTile(
                      icon: Icons.format_size,
                      title: 'حجم خط القراءة',
                      subtitle: '18px • متوسط (Noto Sans)',
                      trailingIcon: Icons.chevron_left,
                      trailingIconColor: AppColors.secondary,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Block 4: Account & security
                _SectionTitle(
                  icon: Icons.shield,
                  title: 'الحساب والأمان',
                ),
                const SizedBox(height: 8),
                _PreferencesCard(
                  children: [
                    _ListTile(
                      icon: Icons.lock_reset,
                      title: 'تعديل كلمة المرور',
                      trailingIcon: Icons.chevron_left,
                      trailingIconColor: AppColors.secondary,
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _ListTile(
                      icon: Icons.cloud_sync,
                      title: 'نسخ احتياطي للمكتبة',
                      subtitle: 'آخر مزامنة: اليوم، 03:15 م',
                      trailingIcon: Icons.chevron_left,
                      trailingIconColor: AppColors.secondary,
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFF1E4D3)),
                    _ListTile(
                      icon: Icons.verified_user,
                      title: 'سياسة الخصوصية والشروط',
                      trailingIcon: Icons.chevron_left,
                      trailingIconColor: AppColors.secondary,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: AppButton(
                    text: 'تسجيل الخروج من الحساب',
                    type: AppButtonType.ghost,
                    icon: const Icon(Icons.logout, size: 20),
                    onPressed: _logout,
                  ),
                ),
                const SizedBox(height: 22),

                // Footer
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.menu_book,
                          size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'تطبيق اقرأ • ملاذك القرائي الهادئ',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'الإصدار 1.0.0',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    appController.logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BookCover(
                        imageUrl: MockData.userProfile.avatarUrl,
                        width: 64,
                        height: 64,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Material(
                        color: AppColors.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            child: const Icon(Icons.photo_camera,
                                size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              MockData.userProfile.name,
                              style: const TextStyle(
                                color: Color(0xFF3E2A1E),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {},
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: const Icon(Icons.edit,
                                    size: 18, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        MockData.userProfile.email,
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_stories,
                                size: 12, color: Color(0xFF4F5D2F)),
                            const SizedBox(width: 4),
                            Text(
                              'عضو في اقرأ منذ يناير 2024',
                              style: TextStyle(
                                color: AppColors.onSecondaryContainer,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFD8CEC3), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _ProfileStat('24', 'كتاباً منجزاً')),
                Expanded(child: _ProfileStat('18', 'يوم الالتزام')),
                Expanded(child: _ProfileStat('4.2k', 'صفحة مقروءة')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
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
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF3E2A1E),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  final List<Widget> children;

  const _PreferencesCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: children),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final VoidCallback? onTap;

  const _ListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF3E2A1E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing! else
                Icon(trailingIcon ?? Icons.chevron_left,
                    size: 20, color: trailingIconColor ?? AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF3E2A1E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Transform.scale(
            scale: 0.85,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentOption {
  final String label;
  final String value;
  const SegmentOption({required this.label, required this.value});
}

class _SegmentedTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<SegmentOption> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const _SegmentedTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ListTile(
          icon: icon,
          title: title,
          subtitle: subtitle,
          trailingIcon: Icons.chevron_left,
          trailingIconColor: AppColors.secondary,
          onTap: () {},
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(options.length, (i) {
              final option = options[i];
              final selected = selectedValue == option.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(option.value),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: selected ? AppColors.onPrimary : AppColors.secondary,
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
