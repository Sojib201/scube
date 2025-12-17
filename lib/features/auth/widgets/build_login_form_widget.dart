import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/auth/widgets/password_field.dart';
import 'package:scub/features/auth/widgets/register_link.dart';
import 'package:scub/features/auth/widgets/username_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'forgot_password_link.dart';
import 'login_button.dart';


class BuildLoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback onLoginSubmitted;
  final VoidCallback onToggleObscureText;

  const BuildLoginFormWidget({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscureText,
    required this.onLoginSubmitted,
    required this.onToggleObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.only(top: 20.h, right: 24.w, left: 24.w, bottom: 80.h),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.h28),

            // Form Fields
            UsernameField(controller: usernameController),
            SizedBox(height: AppSpacing.h16),
            PasswordField(
              controller: passwordController,
              obscureText: obscureText,
              onToggleObscureText: onToggleObscureText,
            ),
            const ForgotPasswordLink(),
            SizedBox(height: AppSpacing.h20),

            // Login Button
            LoginButton(onLoginSubmitted: onLoginSubmitted),

            SizedBox(height: AppSpacing.h20),

            // Register Link
            const RegisterLink(),
          ],
        ),
      ),
    );
  }
}