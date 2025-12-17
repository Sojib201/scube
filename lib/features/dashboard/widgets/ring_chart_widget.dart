import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class RingChartWidget extends StatelessWidget {
  final double totalPower;
  const RingChartWidget({super.key, required this.totalPower});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 140.h,
        width: 140.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.deepBlue, width: 15.w),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Power',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.darkGrey.withOpacity(0.7),
                ),
              ),
              Text(
                '${totalPower.toStringAsFixed(2)} kW',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}