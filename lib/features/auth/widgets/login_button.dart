import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';


class LoginButton extends StatelessWidget {
  final VoidCallback onLoginSubmitted;
  const LoginButton({super.key, required this.onLoginSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : onLoginSubmitted,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child:
          isLoading
              ? SizedBox(
            height: 24.sp,
            width: 24.sp,
            child: const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            'Login',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}