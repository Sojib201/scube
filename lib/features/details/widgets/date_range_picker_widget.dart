import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange selectedDateRange;
  final Future<void> Function(BuildContext) selectDateRange;
  final VoidCallback onDateRangeSearch;

  const DateRangePickerWidget({
    super.key,
    required this.selectedDateRange,
    required this.selectDateRange,
    required this.onDateRangeSearch,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: _buildDateInput(
              context,
              'From Date',
              formatter.format(selectedDateRange.start),
                  () => selectDateRange(context),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildDateInput(
              context,
              'To Date',
              formatter.format(selectedDateRange.end),
                  () => selectDateRange(context),
            ),
          ),
          SizedBox(width: 10.w),
          // Search Button
          Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: AppColors.white, size: 20.sp),
              onPressed: onDateRangeSearch,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput(
      BuildContext context, String label, String dateValue, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grey.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateValue,
              style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
            ),
            Icon(Icons.date_range, color: AppColors.grey, size: 18.sp),
          ],
        ),
      ),
    );
  }
}