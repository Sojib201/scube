import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';
import '../widgets/detail_bloc_content.dart';


class DetailViewScreen extends StatefulWidget {
  const DetailViewScreen({super.key});

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {

  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<DetailViewBloc>().add(LoadDetailData());
      }
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      context.read<DetailViewBloc>().add(LoadCustomDateData(picked.start, picked.end));
    }
  }

  void _onDateRangeSearch() {
    context.read<DetailViewBloc>().add(LoadCustomDateData(
        _selectedDateRange.start,
        _selectedDateRange.end
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkGrey, size: 28.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.w),
                  child: DetailBlocContent(
                    selectDateRange: _selectDateRange,
                    selectedDateRange: _selectedDateRange,
                    onDateRangeSearch: _onDateRangeSearch,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

