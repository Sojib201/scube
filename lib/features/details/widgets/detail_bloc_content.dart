import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/details/widgets/view_toggle_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_state.dart';
import 'circular_chart_widget.dart';
import 'date_range_picker_widget.dart';
import 'date_toggle_bar.dart';
import 'details_card.dart';


class DetailBlocContent extends StatelessWidget {
  final Future<void> Function(BuildContext) selectDateRange;
  final DateTimeRange selectedDateRange;
  final VoidCallback onDateRangeSearch;

  const DetailBlocContent({
    super.key,
    required this.selectDateRange,
    required this.selectedDateRange,
    required this.onDateRangeSearch,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailViewBloc, DetailViewState>(
      builder: (context, state) {
        if (state is DetailViewLoading || state is DetailViewInitial) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (state is DetailViewLoaded) {
          return _buildLoadedContent(context, state);
        }

        return Center(
          child: Text('Error loading data.', style: TextStyle(color: AppColors.red)),
        );
      },
    );
  }

  Widget _buildLoadedContent(BuildContext context, DetailViewLoaded state) {
    final isCustomDate = state.activeDateType == 'Custom Date Data';
    final isDataView = state.activeView == 'Data View';
    final double overlapOffset = 25.h;

    return Stack(
      children: [
        // 1. Main White Container (with Top Border Radius)
        Padding(
          padding: EdgeInsets.only(top: overlapOffset),
          child: Container(
            padding: EdgeInsets.only(top: 40.h),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                // Fixed/Non-scrolling content
                Column(
                  children: [
                    CircularChartWidget(
                      value: state.circularChartValue,
                      unit: state.circularChartUnit,
                    ),

                    SizedBox(height: 30.h),

                    // 3. Date Toggle (Today / Custom) - Only visible in Data View
                    if (isDataView)
                      DateToggleBar(activeDateType: state.activeDateType),

                    // Date Range Picker - Only visible if Data View AND Custom Date is selected
                    if (isCustomDate && isDataView)
                      DateRangePickerWidget(
                        selectedDateRange: selectedDateRange,
                        selectDateRange: selectDateRange,
                        onDateRangeSearch: onDateRangeSearch,
                      ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Scrollable Details List
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: List.generate(state.chartBlocks.length, (index) {
                          final block = state.chartBlocks[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: DetailsCard(
                              block: block,
                              blockIndex: index,
                              isRevenueView: !isDataView,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Positioned Toggle Bar (Data View / Revenue View)
        Positioned(
          left: 16.w,
          right: 16.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ViewToggleBar(activeView: state.activeView),
          ),
        ),
      ],
    );
  }
}