import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';


class ViewToggleBar extends StatelessWidget {
  final String activeView;

  const ViewToggleBar({super.key, required this.activeView});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToggleItem(
            context,
            'Data View',
            activeView,
            onTap: () => context.read<DetailViewBloc>().add(ToggleView('Data View')),
          ),
          _buildToggleItem(
            context,
            'Revenue View',
            activeView,
            onTap: () => context.read<DetailViewBloc>().add(ToggleView('Revenue View')),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
      BuildContext context, String title, String activeView, {required VoidCallback onTap}) {
    final isActive = activeView == title;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  //color: isActive ? AppColors.primary : AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.grey,
                  )
                ),
                child: Container(
                  //padding: EdgeInsets.all(12),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.grey,
                  fontSize: 16.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}