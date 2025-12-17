import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class TabBarWidget extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const TabBarWidget({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('Summary'),
          _buildTabItem('SLD'),
          _buildTabItem('Data'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title) {
    final isActive = activeTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChange(title),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11.r),
              topRight: Radius.circular(11.r),
            ),
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