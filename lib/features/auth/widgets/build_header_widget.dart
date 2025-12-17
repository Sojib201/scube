import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class BuildHeaderWidget extends StatelessWidget {
  const BuildHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 80.h,
        left: 30.w,
        right: 30.w,
      ),
      color: AppColors.primary,
      child: Column(
        children: [
          Builder(
            builder: (context) {
              try {
                return Image.asset(
                  AppAssets.asset1,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                );
              } catch (e) {
                return Icon(
                  Icons.speed_outlined,
                  color: AppColors.white,
                  size: 80.sp,
                );
              }
            },
          ),
          SizedBox(height: AppSpacing.h8),
          Text(
            'SCUBE',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Control & Monitoring System',
            style: TextStyle(
                color: AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}