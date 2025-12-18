import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/core/constants/app_colors.dart';
import 'package:scub/features/details/bloc/detail_bloc.dart';
import 'package:scub/features/details/bloc/detail_event.dart';
import 'package:scub/features/details/widgets/detail_list_item.dart';
import '../bloc/detail_state.dart';


class DetailsCard extends StatelessWidget {
  final ChartDataBlock block;
  final int blockIndex;
  final bool isRevenueView;

  const DetailsCard({
    super.key,
    required this.block,
    required this.blockIndex,
    required this.isRevenueView,
  });

  @override
  Widget build(BuildContext context) {
    final valueUnit = isRevenueView ? 'tk' : 'kW';
    final mainValueColor = isRevenueView ? AppColors.primary : Colors.black;
    final listTitle = isRevenueView ? 'Data & Cost Info' : 'Energy Chart';

    return Container(
      padding: !isRevenueView? EdgeInsets.all(15.r) : null,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.grey),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRevenueView)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      block.title ?? '',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      '${block.mainValue ?? ''} $valueUnit',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: mainValueColor,
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 15.h),
              ],
            ),

          if (isRevenueView)
            GestureDetector(
              onTap: () {
                context.read<DetailViewBloc>().add(ToggleChartExpand(blockIndex));
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: block.isExpanded ? 8.h : 0.h),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: block.isExpanded ? AppColors.grey : Colors.white
                      )
                    ),
                    borderRadius: BorderRadius.circular(12.r)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart, color: AppColors.darkGrey, size: 24.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            listTitle,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            block.isExpanded ? Icons.keyboard_double_arrow_up_outlined : Icons.keyboard_double_arrow_down_outlined,
                            color: AppColors.white,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (block.isExpanded || !isRevenueView)
            Column(
              children: [
                if (!isRevenueView)
                  Divider(color: AppColors.lightGrey, height: 1.h, thickness: 1.0),
                ...block.detailList.map((data) => DetailListItem(data: data, isRevenueView: isRevenueView)),
              ],
            ),
        ],
      ),
    );
  }
}