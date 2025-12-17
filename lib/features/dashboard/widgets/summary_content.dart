import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/dashboard/widgets/ring_chart_widget.dart';
import 'package:scub/features/dashboard/widgets/source_load_list_item.dart';
import 'package:scub/features/dashboard/widgets/source_load_toggle.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';


class SummaryContent extends StatelessWidget {
  final double todayTotal;
  final String activeToggle;
  final Function(String) onToggleChange;

  const SummaryContent({
    super.key,
    required this.todayTotal,
    required this.activeToggle,
    required this.onToggleChange,
  });

  // Mock list items, replace with state data
  List<Map<String, dynamic>> get _mockSourceList => [
    {'icon': AppAssets.solarCell, 'title': 'Data View', 'status': 'Active', 'iconColor': AppColors.primary, 'badgeColor': AppColors.purple},
    {'icon': AppAssets.asset2, 'title': 'Data Type 2', 'status': 'Active', 'iconColor': AppColors.orange, 'badgeColor': AppColors.primary},
    {'icon': AppAssets.power, 'title': 'Data Type 3', 'status': 'Inactive', 'iconColor': AppColors.red, 'badgeColor': AppColors.red},
  ];

  List<Map<String, dynamic>> get _mockLoadList => [
    {'icon': AppAssets.solarCell, 'title': 'Motor Load 1', 'status': 'Active', 'iconColor': Colors.red, 'badgeColor': AppColors.purple},
    {'icon': AppAssets.power, 'title': 'Lighting Circuit', 'status': 'Active', 'iconColor': AppColors.orange, 'badgeColor': AppColors.primary},
    {'icon': AppAssets.asset2, 'title': 'AC Unit 3', 'status': 'Inactive', 'iconColor': AppColors.grey, 'badgeColor': AppColors.red},
  ];


  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        children: [
          // Fixed Header Section
          Column(
            children: [
              SizedBox(height: 5.h),
              _buildElectricityTitle(),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey, width: 0.6.w),
                ),
              ),
              SizedBox(height: 10.h),
              RingChartWidget(totalPower: todayTotal / 1000), // Ring Chart
              SizedBox(height: 16.h),
              SourceLoadToggle(activeToggle: activeToggle, onToggleChange: onToggleChange), // Toggle
              SizedBox(height: 5.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey, width: 0.6.w),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),

          // Scrollable List Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildListItems(context),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElectricityTitle() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(
          'Electricity',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems(BuildContext context) {
    final list = activeToggle == 'Source' ? _mockSourceList : _mockLoadList;

    return list.map((item) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: SourceLoadListItem(
          icon: item['icon'],
          title: item['title'],
          status: item['status'],
          iconColor: item['iconColor'],
          badgeColor: item['badgeColor'],
          // Navigate only if it's the 'Data View' item under the 'Source' toggle
          isNavigatable: activeToggle == 'Source' && item['title'] == 'Data View',
        ),
      );
    }).toList();
  }
}