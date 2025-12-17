import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/dashboard/widgets/summary_content.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';

class BlocContentWidget extends StatelessWidget {
  final String activeToggle;
  final Function(String) onToggleChange;

  const BlocContentWidget({
    super.key,
    required this.activeToggle,
    required this.onToggleChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // Mock data
        // List<SourceItem> mockSources = [];
        // double mockTodayTotal = 5530.0;

        if (state is DashboardLoading) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        if (state is DashboardEmpty) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Center(
                child: Image.asset(
                  AppAssets.noData,
                  width: 300.w,
                  height: 300.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        }

        // DashboardLoaded state or initial state with mock data
        return SummaryContent(
          // Here you would pass actual state data instead of mock
          todayTotal: 5530.0,
          activeToggle: activeToggle,
          onToggleChange: onToggleChange,
        );
      },
    );
  }
}