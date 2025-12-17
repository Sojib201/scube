import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class ShortcutButtonsGrid extends StatelessWidget {
  const ShortcutButtonsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> shortcuts = [
      {'title': 'Analysis Pro', 'icon': AppAssets.chart},
      {'title': 'G. Generator', 'icon': AppAssets.generator},
      {'title': 'Plant Summery', 'icon': AppAssets.charge},
      {'title': 'Natural Gas', 'icon': AppAssets.fire},
      {'title': 'D. Generator', 'icon': AppAssets.generator},
      {'title': 'Water Process', 'icon': AppAssets.waterProcess},
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: shortcuts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemBuilder: (context, index) {
        final item = shortcuts[index];
        return _buildShortcutButton(
          item['title'] as String,
          item['icon'] as String,
        );
      },
    );
  }

  Widget _buildShortcutButton(String title, String icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey, width: 0.6.w),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Placeholder functionality
        },
        borderRadius: BorderRadius.circular(15.r),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}