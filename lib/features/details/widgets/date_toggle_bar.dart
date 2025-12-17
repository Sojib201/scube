import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';


class DateToggleBar extends StatelessWidget {
  final String activeDateType;
  const DateToggleBar({super.key, required this.activeDateType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToggleItemStyled(
            context,
            'Today Data',
            activeDateType,
            onTap: () {
              context.read<DetailViewBloc>().add(ToggleDateType('Today Data'));
            },
          ),
          _buildToggleItemStyled(
            context,
            'Custom Date Data',
            activeDateType,
            onTap: () {
              context.read<DetailViewBloc>().add(ToggleDateType('Custom Date Data'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItemStyled(
      BuildContext context, String title, String activeDateType, {required VoidCallback onTap}) {
    final isActive = activeDateType == title;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.grey,
                  shape: BoxShape.circle,
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