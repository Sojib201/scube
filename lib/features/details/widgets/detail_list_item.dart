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
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h,left: 12.w, right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${data.title} :",
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                  ),
                  TextSpan(
                    text: '  ${data.dataValue} (${data.percentage})',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.black,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cost ${data.title.substring(data.title.length - 1)} :',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                  ),
                  TextSpan(
                    text: ' ${data.costValue} ৳',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.black,fontWeight: FontWeight.w500),
                  ),

                ],
              ),
            ),

            if (data.title != 'Data 4')
              SizedBox(height: 8.h),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: data.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 6.h),
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
            SizedBox(width: 10.w),

            Container(
              height: 50.h,
              width: 0.1.w,
              decoration: BoxDecoration(
                color: AppColors.grey.shade50,
                border: Border.all(
                  width: 0.5.w
                )
              ),
            ),
            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Data   : ',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                        ),
                        TextSpan(
                          text: '${data.dataValue} (${data.percentage})',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.black,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cost   : ',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
                        ),
                        TextSpan(
                          text: '${data.costValue} ৳',
                          style: TextStyle(fontSize: 14.sp, color: AppColors.black,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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