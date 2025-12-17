import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/details/bloc/detail_state.dart';
import '../../../../core/constants/app_colors.dart';

class DetailListItem extends StatelessWidget {
  final DetailData data;
  final bool isRevenueView;

  const DetailListItem({
    super.key,
    required this.data,
    required this.isRevenueView,
  });

  @override
  Widget build(BuildContext context) {
    if (isRevenueView) {
      // Revenue View style (simple text list)
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data.title} : ${data.dataValue} (${data.percentage})',
              style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2.h),
            Text(
              'Cost ${data.title.substring(data.title.length - 1)} : ${data.costValue} ৳',
              style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
            ),
            if (data.title != 'Data 4')
              SizedBox(height: 8.h),
          ],
        ),
      );
    }

    // Data View style (with dot, container, and arrow)
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.lightGrey, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // Left Indicator (Colored dot and Title)
            Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: data.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.w),

            // Middle Data (Data and Cost)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Data: ',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                        ),
                        TextSpan(
                          text: '${data.dataValue} (${data.percentage})',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cost: ',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                        ),
                        TextSpan(
                          text: '${data.costValue} ৳',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grey,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}