import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/group.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Create Group or Challenge screen (Screen 8).
///
/// Creates a new reading group/challenge in local state and shows a success
/// bottom sheet with the generated join code.
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController =
      TextEditingController(text: 'رفاق الفكر والفلسفة');
  final _descriptionController = TextEditingController(
      text: 'قراءة معمّقة ومناقشات أسبوعية لأمهات كتب الفلسفة والتأمل الإنساني.');
  final _formKey = GlobalKey<FormState>();

  GroupPrivacy _privacy = GroupPrivacy.private;
  bool _showSuccess = false;

  // Selected book (mocked selection)
  final String _bookTitle = 'طريق الحكمة وفنون العيش';
  final String _bookAuthor = 'د. عبد الرحمن الفهد';
  final int _bookPages = 320;
  final String _bookCover =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAs4GnVO8FGUn8CqMs1GYNO51s35RegbTg9E6zCz6iuYKSp5WOTyfQ9jpSCenv1HLinyVFBRVLXEWD2nPXXPEe5iD-HMy6s9Be_ooc0f1DDlbTisqNpLjUyP8RTmYEx0A_gQq3HmkZE7jm_nFgDEIUNajxeSDq5yrTjOGuvT-19jStlplxarx2L5PkWsH7ZM-f3ft3YVUfADHc3UfbyzAf2YvVsRJeXAyO3OHXSXzRXlZ3aT1TMHXU5TQ';
  final String _bookCategory = 'فلسفة وتأمل';
  final int _durationDays = 30;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createGroup() {
    if (!_formKey.currentState!.validate()) return;
    appController.createGroup(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      bookTitle: _bookTitle,
      bookCoverUrl: _bookCover,
      totalPages: _bookPages,
      daysDuration: _durationDays,
      privacy: _privacy,
    );
    setState(() => _showSuccess = true);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: _showSuccess ? _SuccessSheet() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Text(
          'إنشاء مجموعة أو تحدي',
          style: TextStyle(
            color: Color(0xFF3E2A1E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'املأ بيانات المجموعة لتبدأ قراءة الكتاب مع الرفاق.',
          style: TextStyle(color: AppColors.secondary, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Block 1: Group name & description
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E4D3),
                    border: Border.all(color: const Color(0xFFCDAA85)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'اسم المجموعة ووصفها',
                            style: TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2D1BE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'مطلوب',
                              style: TextStyle(
                                color: Color(0xFF4F5D2F),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _nameController,
                        placeholder: 'مثال: رفاق الفكر والفلسفة',
                        prefixIcon: const Icon(Icons.groups,
                            size: 22, color: Color(0xFF4F5D2F)),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'الرجاء إدخال اسم المجموعة'
                                : null,
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                        controller: _descriptionController,
                        placeholder:
                            'أضف نبذة سريعة عن أهداف المجموعة ومسار القراءة...',
                        maxLines: 2,
                        prefixIcon: const Icon(Icons.description,
                            size: 22, color: Color(0xFF4F5D2F)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Block 2: Selected book
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E4D3),
                    border: Border.all(color: const Color(0xFFCDAA85)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الكتاب المعتمد للتحدي',
                            style: TextStyle(
                              color: Color(0xFF3E2A1E),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sync_alt,
                                    size: 16, color: Color(0xFF4F5D2F)),
                                const SizedBox(width: 4),
                                const Text(
                                  'تغيير الكتاب',
                                  style: TextStyle(
                                    color: Color(0xFF4F5D2F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFCDAA85)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            BookCover(
                              imageUrl: _bookCover,
                              width: 50,
                              height: 70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2D1BE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$_bookCategory • $_durationDays يوماً',
                                      style: const TextStyle(
                                        color: Color(0xFF4F5D2F),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _bookTitle,
                                    style: const TextStyle(
                                      color: Color(0xFF3E2A1E),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$_bookAuthor • $_bookPages صفحة',
                                    style: const TextStyle(
                                      color: Color(0xFF4F5D2F),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Block 3: Group type & privacy
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E4D3),
                    border: Border.all(color: const Color(0xFFCDAA85)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نوع المجموعة ومستوى الخصوصية',
                        style: TextStyle(
                          color: Color(0xFF3E2A1E),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _PrivacyOption(
                        value: GroupPrivacy.private,
                        groupValue: _privacy,
                        title: 'مجموعة خاصة (برمز دعوة فقط)',
                        icon: Icons.lock,
                        iconColor: const Color(0xFF6B4630),
                        detail:
                            'الانضمام برمز أو رابط دعوة حصري من المشرف فقط دون ظهور في الدليل العام.',
                        selected: _privacy == GroupPrivacy.private,
                        onChanged: (v) => setState(() => _privacy = v!),
                      ),
                      const SizedBox(height: 10),
                      _PrivacyOption(
                        value: GroupPrivacy.public,
                        groupValue: _privacy,
                        title: 'تحدي عام مفتوح لجميع القرّاء',
                        icon: Icons.public,
                        iconColor: const Color(0xFF4F5D2F),
                        detail:
                            'متاح لجميع أفراد مجتمع القراءة للمشاركة والتنافس في جداول الإنجاز.',
                        selected: _privacy == GroupPrivacy.public,
                        onChanged: (v) => setState(() => _privacy = v!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Block 4: Primary CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: AppButton(
                    text: 'تأكيد وإنشاء المجموعة',
                    type: AppButtonType.primary,
                    icon: const Icon(Icons.rocket_launch, size: 20),
                    onPressed: _createGroup,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  final GroupPrivacy value;
  final GroupPrivacy groupValue;
  final String title;
  final IconData icon;
  final Color iconColor;
  final String detail;
  final bool selected;
  final ValueChanged<GroupPrivacy?> onChanged;

  const _PrivacyOption({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.detail,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFFBF6EE),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFCDAA85),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFCDAA85),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_circle,
                      size: 10, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: const Color(0xFF3E2A1E),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(icon, size: 14, color: iconColor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final group = appController.groups.last;
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.celebration,
                    size: 36, color: AppColors.onPrimaryFixed),
              ),
              const SizedBox(height: 14),
              Text(
                'تم إنشاء مجموعتك بنجاح! 🎉',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF3E2A1E),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أصبحت مجموعة "${group.name}" جاهزة الآن. شارك الرمز مع أصدقائك لبدء القراءة معاً.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              // Join code card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'رمز الانضمام الحصري:',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            group.joinCode,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: 'نسخ الرمز',
                      type: AppButtonType.secondary,
                      icon: const Icon(Icons.content_copy, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('تم نسخ الرمز بنجاح!'),
                          backgroundColor: Color(0xFF4F5D2F),
                        ));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: AppButton(
                  text: 'مشاركة رابط الدعوة المباشر',
                  type: AppButtonType.secondary,
                  icon: const Icon(Icons.ios_share, size: 20),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppButton(
              text: 'الانتقال إلى صفحة المجموعة',
              type: AppButtonType.primary,
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () {
                // navigate to group details of the newly created group
                Navigator.of(context).pushNamed(AppRoutes.groupDetails);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
