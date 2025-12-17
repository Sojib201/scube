import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../details/view/details_view_screen.dart';

class SourceLoadListItem extends StatelessWidget {
  final String icon;
  final String title;
  final String status;
  final Color iconColor;
  final Color badgeColor;
  final bool isNavigatable;

  const SourceLoadListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    required this.iconColor,
    required this.badgeColor,
    this.isNavigatable = false,
  });

  @override
  Widget build(BuildContext context) {
    const String data1 = '55505.63';
    const String data2 = '58805.63';
    final bool isActive = status == 'Active';

    return InkWell(
      onTap:() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailViewScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.grey, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isActive ? '(Active)' : '(Inactive)',
                        style: TextStyle(
                          color: isActive ? AppColors.primary : AppColors.red,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Data 1 : $data1',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Data 2 : $data2',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkGrey.withOpacity(0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}