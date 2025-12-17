import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';

class EmptyDashboardScreen extends StatefulWidget {
  const EmptyDashboardScreen({super.key});

  @override
  State<EmptyDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<EmptyDashboardScreen> {

  @override
  void initState() {
    super.initState();

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
      ), // 1. AppBar Widget
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.grey, width: 1.w),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child:  Image.asset(
                      AppAssets.noData,
                      width: 300.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

