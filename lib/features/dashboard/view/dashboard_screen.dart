import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../widgets/bloc_content_widget.dart';
import '../widgets/placeholder_content.dart';
import '../widgets/shortcut_buttons_grid.dart';
import '../widgets/tab_bar_widget.dart';

class SourceItem {}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _activeTab = 'Summary';
  String _activeToggle = 'Source';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<DashboardBloc>().add(LoadDashboardData());
      }
    });
  }

  void _setActiveTab(String title) {
    setState(() {
      _activeTab = title;
      if (title == 'Summary') {
        _activeToggle = 'Source';
      }
    });
  }

  void _setActiveToggle(String title) {
    setState(() {
      _activeToggle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'SCM',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppColors.darkGrey,
              size: 28.sp,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.grey, width: 1.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      TabBarWidget(
                        activeTab: _activeTab,
                        onTabChange: _setActiveTab,
                      ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                          child: Column(
                            children: [
                              if (_activeTab == 'Summary')
                                BlocContentWidget(
                                  activeToggle: _activeToggle,
                                  onToggleChange: _setActiveToggle,
                                )
                              else if (_activeTab == 'SLD')
                                Expanded(
                                  child: PlaceholderContent(
                                    title: 'SLD View',
                                  ),
                                )
                              else if (_activeTab == 'Data')
                                  Expanded(
                                    child: PlaceholderContent(
                                      title: 'Raw Data',
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              const ShortcutButtonsGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
