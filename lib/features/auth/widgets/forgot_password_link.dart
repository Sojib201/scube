import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Add Forgot Password logic
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
        ),
      ),
    );
  }
}