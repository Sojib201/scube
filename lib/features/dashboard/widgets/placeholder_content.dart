import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class PlaceholderContent extends StatelessWidget {
  final String title;

  const PlaceholderContent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.noData,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10.h),
          Text(
            textAlign: TextAlign.center,
            '$title Content is under development.',
            style: TextStyle(fontSize: 18.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}