import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// حقل إدخال موحّد لصفحات المصادقة، مصمّم بنفس لغة التطبيق:
/// حواف دائرية، خلفية بلون dividerColor، أيقونة باللون الأساسي البني،
/// وخط Sora (موروث من الثيم).
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MyTexeStyle.normalTitleText(size: 15)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: MyTexeStyle.normalTitleText(size: 15),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(icon, color: MyAppColor.primaryColor, size: 22),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: MyTexeStyle.subTitleText(size: 15),
            fillColor: MyAppColor.dividerColor,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: MyAppColor.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
