import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../widgets/widgets.dart';

/// Login and Registration screen (Screen 2).
///
/// Supports switching between login and register modes using local state only.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegister = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchMode(bool register) {
    setState(() => _isRegister = register);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // Simulate a local authentication round-trip.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    appController.login();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Brand header
                    const SizedBox(height: 24),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.auto_stories,
                          size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'اقرأ',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مساحتك الهادئة لبناء عادة القراءة اليومية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.outlineVariant, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowTint,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title stack
                            Text(
                              _isRegister
                                  ? 'انضم إلى مجتمع اقرأ'
                                  : 'مرحباً بك مجدداً',
                              style: const TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isRegister
                                  ? 'ابدأ رحلتك لتأسيس عادة قرائية راسخة ومُلهمة'
                                  : 'سجّل دخولك لمواصلة خطتك القرائية وتأملاتك اليومية',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Segmented tab switcher
                            _SegmentedControl(
                              loginLabel: 'تسجيل الدخول',
                              registerLabel: 'حساب جديد',
                              isRegister: _isRegister,
                              onChanged: _switchMode,
                            ),
                            const SizedBox(height: 24),

                            // Full name (register only)
                            if (_isRegister) ...[
                              AppTextField(
                                controller: _nameController,
                                label: 'الاسم الكامل',
                                placeholder: 'مثال: يوسف الأحمدي',
                                prefixIcon: const Icon(Icons.badge,
                                    size: 22, color: AppColors.outline),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'الرجاء إدخال الاسم الكامل'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email
                            AppTextField(
                              controller: _emailController,
                              label: 'البريد الإلكتروني',
                              placeholder: 'reader@iqra.app',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.mail,
                                  size: 22, color: AppColors.outline),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'الرجاء إدخال البريد الإلكتروني';
                                }
                                if (!v.contains('@')) {
                                  return 'الرجاء إدخال بريد إلكتروني صالح';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'كلمة المرور',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (!_isRegister)
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'نسيت كلمة المرور؟',
                                          style: TextStyle(
                                            color: Color(0xFF4F5D2F),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _passwordController,
                                  label: '',
                                  placeholder: '••••••••',
                                  obscureText: _obscurePassword,
                                  prefixIcon: const Icon(Icons.lock,
                                      size: 22, color: AppColors.outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 20,
                                      color: AppColors.outline,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                  validator: (v) =>
                                      (v == null || v.length < 6)
                                          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                                          : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Submit CTA
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: AppButton(
                                text: _isRegister
                                    ? 'إنشاء حسابك الآن'
                                    : 'تسجيل الدخول',
                                type: AppButtonType.primary,
                                onPressed: _submit,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Separator
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'أو المتابعة عبر',
                            style: TextStyle(
                              color: AppColors.outlineVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Google authentication
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const SizedBox(
                          width: 20,
                          height: 20,
                          child: ColoredBox(
                            color: Color(0xFFEA4335),
                            child: Icon(Icons.g_mobiledata,
                                size: 18, color: Colors.white),
                          ),
                        ),
                        label: const Text(
                          'المتابعة باستخدام Google',
                          style: TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.outlineVariant, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor: AppColors.surface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bottom inline switcher
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRegister ? 'لديك حساب بالفعل؟' : 'ليس لديك حساب؟',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _switchMode(!_isRegister),
                          child: Text(
                            _isRegister ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final String loginLabel;
  final String registerLabel;
  final bool isRegister;
  final ValueChanged<bool> onChanged;

  const _SegmentedControl({
    required this.loginLabel,
    required this.registerLabel,
    required this.isRegister,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Tab(
              label: loginLabel,
              selected: !isRegister,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _Tab(
              label: registerLabel,
              selected: isRegister,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.onPrimary : AppColors.secondary,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
