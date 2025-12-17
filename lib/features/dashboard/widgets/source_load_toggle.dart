import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class SourceLoadToggle extends StatelessWidget {
  final String activeToggle;
  final Function(String) onToggleChange;

  const SourceLoadToggle({
    super.key,
    required this.activeToggle,
    required this.onToggleChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          _buildToggleItemButton('Source'),
          SizedBox(width: 8.w),
          _buildToggleItemButton('Load'),
        ],
      ),
    );
  }

  Widget _buildToggleItemButton(String title) {
    final isActive = activeToggle == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggleChange(title),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.darkGrey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}