import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Styled text input field matching the designs:
/// cream fill, parchment outline, primary focus border, right-aligned text.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hintText = placeholder ?? hint ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          textInputAction: textInputAction,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 15,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
              fontSize: 15,
            ),
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: suffixIcon,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
