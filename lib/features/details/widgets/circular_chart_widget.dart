import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';

class CircularChartWidget extends StatelessWidget {
  final String value;
  final String unit;

  const CircularChartWidget({
    super.key,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double activeFill = unit == 'tk' ? 80.0 : double.tryParse(value.split('.').first) ?? 55.0;

    if (activeFill < 0) activeFill = 0;
    if (activeFill > 100) activeFill = 100;
    double remainingFill = 100.0 - activeFill;

    final primaryColor = unit == 'tk' ? AppColors.primary : AppColors.primary;

    return Center(
      child: SizedBox(
        height: 150.h,
        width: 150.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                startDegreeOffset: 270,
                sectionsSpace: 0,
                centerSpaceRadius: 60.r,
                sections: [
                  PieChartSectionData(
                    value: activeFill,
                    color: primaryColor,
                    radius: 12.w,
                    title: '',
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: remainingFill,
                    color: primaryColor.withOpacity(0.2),
                    radius: 12.w,
                    title: '',
                    showTitle: false,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    unit,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}