import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'input_decoration.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscureText;

  const PasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: buildInputDecoration('Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 22.sp,
            color: AppColors.grey,
          ),
          onPressed: onToggleObscureText,
        ),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Enter your password' : null,
    );
  }
}