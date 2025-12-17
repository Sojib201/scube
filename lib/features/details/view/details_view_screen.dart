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

  // Default date range state to hold the selected range
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

  // Function to show a date range picker modal (Must remain in State class)
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
      // Trigger data reload after selecting new range
      context.read<DetailViewBloc>().add(LoadCustomDateData(picked.start, picked.end));
    }
  }

  // Helper function to handle date range submission (Must remain in State class)
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
              /* Handle notifications */
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
                  child: DetailBlocContent( // 2. Separated BLoC Content Widget
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


///2nd old
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
//
// import '../../../core/constants/app_colors.dart';
// import '../bloc/detail_bloc.dart';
// import '../bloc/detail_event.dart';
// import '../bloc/detail_state.dart';
//
// class DetailViewScreen extends StatefulWidget {
//   const DetailViewScreen({super.key});
//
//   @override
//   State<DetailViewScreen> createState() => _DetailViewScreenState();
// }
//
// class _DetailViewScreenState extends State<DetailViewScreen> {
//
//   // Default date range state to hold the selected range
//   DateTimeRange _selectedDateRange = DateTimeRange(
//     start: DateTime.now().subtract(const Duration(days: 7)),
//     end: DateTime.now(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (context.mounted) {
//         context.read<DetailViewBloc>().add(LoadDetailData());
//       }
//     });
//   }
//
//   // Function to show a date range picker modal
//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: _selectedDateRange,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: AppColors.primary,
//             colorScheme: ColorScheme.light(primary: AppColors.primary),
//             buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDateRange) {
//       setState(() {
//         _selectedDateRange = picked;
//       });
//       // Optionally trigger data reload after selecting new range
//       // context.read<DetailViewBloc>().add(LoadCustomDateData(picked.start, picked.end));
//     }
//   }
//
//   // Helper function to build Bloc content
//   Widget _buildBlocContent() {
//     return BlocBuilder<DetailViewBloc, DetailViewState>(
//       builder: (context, state) {
//         if (state is DetailViewLoading || state is DetailViewInitial) {
//           return Center(child: CircularProgressIndicator(color: AppColors.primary));
//         }
//
//         if (state is DetailViewLoaded) {
//           return _buildLoadedContent(context, state);
//         }
//
//         return Center(
//           child: Text('Error loading data.', style: TextStyle(color: AppColors.red)),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrey,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.darkGrey, size: 28.sp),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'SCM',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_none,
//               color: AppColors.darkGrey,
//               size: 28.sp,
//             ),
//             onPressed: () {
//               /* Handle notifications */
//             },
//           ),
//         ],
//       ),
//
//       // UPDATED BODY STRUCTURE
//       body: SafeArea(
//           child: Column( // Column is necessary to use Expanded
//             children: [
//               // Expanded for the main content area (which contains the Stack/Bloc)
//               Expanded(
//                 child: Padding(
//                     padding: EdgeInsets.only(top: 16.w), // Horizontal padding for the white container
//                     child: _buildBlocContent() // BlocBuilder inside the Expanded area
//                 ),
//               ),
//               // Placeholder for fixed bottom buttons/widgets if any
//             ],
//           )
//       ),
//     );
//   }
//
//   Widget _buildLoadedContent(BuildContext context, DetailViewLoaded state) {
//     final isCustomDate = state.activeDateType == 'Custom Date Data';
//     final isDataView = state.activeView == 'Data View';
//
//     final double toggleBarHeight = 50.h;
//     final double overlapOffset = 25.h;
//
//     // Get screen width for correctly placing the positioned toggle bar
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     return Stack(
//
//         children:[
//           // 1. Main White Container (with Top Border Radius)
//           Padding(
//             padding: EdgeInsets.only(top: overlapOffset),
//             child: Container(
//               padding: EdgeInsets.only(top: 40.h),
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   border: Border.all(
//                       color: AppColors.grey
//                   ),
//                   borderRadius: BorderRadius.only(
//                     // Applied the requested border radius (12.r or 24.r, using 24.r for prominent design)
//                       topLeft: Radius.circular(24.r),
//                       topRight: Radius.circular(24.r)
//                   )
//               ),
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       _buildCircularChart(state.circularChartValue, state.circularChartUnit),
//
//                       SizedBox(height: 30.h),
//
//                       // 3. Date Toggle (Today / Custom) - Only visible in Data View
//                       if (isDataView)
//                         _buildDateToggle(context, state.activeDateType, isDataView: isDataView),
//
//                       // Date Range Picker - Only visible if Data View AND Custom Date is selected
//                       if (isCustomDate && isDataView)
//                         _buildDateRangePicker(context),
//                     ],
//                   ),
//
//                   SizedBox(height: 20.h),
//
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: Column(
//                           children: List.generate(
//                               state.chartBlocks.length, (index) {
//                             final block = state.chartBlocks[index];
//                             return Padding(
//                               padding: EdgeInsets.only(bottom: 20.h),
//                               child: _buildDetailsCard(
//                                 block.mainValue ?? '',
//                                 block.detailList,
//                                 title: block.title ?? '',
//                                 isExpanded: block.isExpanded,
//                                 blockIndex: index,
//                                 isRevenueView: !isDataView,
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//
//             ),
//           ),
//
//           Positioned(
//             //top: 0,
//               left: 16.w,
//               right: 16.w,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: _buildViewToggle(context, state.activeView),
//               )
//           )
//         ]
//     );
//   }
//
//   // --- 1. Toggle Bar (Data View / Revenue View) ---
//   Widget _buildViewToggle(BuildContext context, String activeView) {
//     // Make the toggle bar take the full horizontal space minus the padding
//     return Container(
//       // Adjusted width to be dynamic, matching the main content area width
//       width: MediaQuery.of(context).size.width - (16.w * 2),
//       height: 50.h,
//       //padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         border: Border.all(
//             color: AppColors.grey
//         ),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildToggleItem(
//             context,
//             'Data View',
//             activeView,
//             onTap: () => context.read<DetailViewBloc>().add(ToggleView('Data View')),
//           ),
//           _buildToggleItem(
//             context,
//             'Revenue View',
//             activeView,
//             onTap: () => context.read<DetailViewBloc>().add(ToggleView('Revenue View')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleItem(
//       BuildContext context, String title, String activeView, {required VoidCallback onTap}) {
//     final isActive = activeView == title;
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           // decoration: BoxDecoration(
//           //   color: isActive ? AppColors.white : Colors.transparent,
//           //   borderRadius: BorderRadius.circular(30.r),
//           //   border: isActive ? Border.all(color: AppColors.lightGrey) : null,
//           // ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: isActive ? AppColors.primary : AppColors.grey,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: isActive ? AppColors.primary : AppColors.grey,
//                     fontSize: 16.sp,
//                     fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- 2. Circular Indicator (fl_chart implementation) ---
//   Widget _buildCircularChart(String value, String unit) {
//     // Determine fill based on view. Revenue View (tk) uses a mock percentage.
//     double activeFill = unit == 'tk' ? 80.0 : double.tryParse(value.split('.').first) ?? 55.0;
//
//     // Ensure activeFill is within 0 to 100
//     if (activeFill < 0) activeFill = 0;
//     if (activeFill > 100) activeFill = 100;
//     double remainingFill = 100.0 - activeFill;
//
//     // Choose color dynamically (Primary for Data View, Green/similar for Revenue View)
//     final primaryColor = unit == 'tk' ? AppColors.primary : AppColors.primary; // Kept blue as per screenshot, but often revenue is green
//
//
//     return Center(
//       child: SizedBox(
//         height: 150.h,
//         width: 150.w,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             PieChart(
//               PieChartData(
//                 startDegreeOffset: 270,
//                 sectionsSpace: 0,
//                 centerSpaceRadius: 60.r,
//                 sections: [
//                   // Active Data Arc
//                   PieChartSectionData(
//                     value: activeFill,
//                     color: primaryColor,
//                     radius: 12.w,
//                     title: '',
//                     showTitle: false,
//                   ),
//                   // Background Arc
//                   PieChartSectionData(
//                     value: remainingFill,
//                     color: primaryColor.withOpacity(0.2),
//                     radius: 12.w,
//                     title: '',
//                     showTitle: false,
//                   ),
//                 ],
//               ),
//             ),
//             // The text in the center
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.darkGrey,
//                     ),
//                   ),
//                   Text(
//                     unit,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateToggle(BuildContext context, String activeDateType, {required bool isDataView}) {
//     // This widget should only display in Data View, which is handled in _buildLoadedContent.
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Today Data
//           _buildDateToggleItemStyled(
//             context,
//             'Today Data',
//             activeDateType,
//             onTap: () {
//               context.read<DetailViewBloc>().add(ToggleDateType('Today Data'));
//             },
//           ),
//
//           // Add a small spacer between the two toggles
//           // SizedBox(width: 16.w),
//
//           // Custom Date Data
//           _buildDateToggleItemStyled(
//             context,
//             'Custom Date Data',
//             activeDateType,
//             onTap: () {
//               context.read<DetailViewBloc>().add(ToggleDateType('Custom Date Data'));
//             },
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   // NEW: Styled Date Toggle Item (similar to _buildToggleItem)
//   Widget _buildDateToggleItemStyled(
//       BuildContext context, String title, String activeDateType, {required VoidCallback onTap}) {
//     final isActive = activeDateType == title;
//     return Expanded( // Use Expanded to make the buttons share space
//       child: GestureDetector(
//         onTap: onTap,
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Small indicator dot (Blue for Today, Gray/Orange for Custom - using Primary for consistency)
//               Container(
//                 width: 8.w,
//                 height: 8.w,
//                 decoration: BoxDecoration(
//                   color: isActive ? AppColors.primary : AppColors.grey,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: isActive ? AppColors.primary : AppColors.grey,
//                   fontSize: 16.sp,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateRangePicker(BuildContext context) {
//     // Format dates for display
//     final DateFormat formatter = DateFormat('dd-MM-yyyy');
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       child: Row(
//         children: [
//           Expanded(child: _buildDateInput(
//             context,
//             'From Date',
//             formatter.format(_selectedDateRange.start),
//                 () => _selectDateRange(context),
//           )),
//           SizedBox(width: 10.w),
//           Expanded(child: _buildDateInput(
//             context,
//             'To Date',
//             formatter.format(_selectedDateRange.end),
//                 () => _selectDateRange(context),
//           )),
//           SizedBox(width: 10.w),
//           // Search Button
//           Container(
//             height: 40.h,
//             width: 40.w,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.search, color: AppColors.white, size: 20.sp),
//               onPressed: () {
//                 // Trigger BLoC event to load data for the selected range
//                 context.read<DetailViewBloc>().add(LoadCustomDateData(
//                     _selectedDateRange.start,
//                     _selectedDateRange.end
//                 ));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateInput(BuildContext context, String label, String dateValue, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 40.h,
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(8.r),
//           border: Border.all(color: AppColors.grey.withOpacity(0.5)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               dateValue,
//               style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//             ),
//             Icon(Icons.date_range, color: AppColors.grey, size: 18.sp),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- 4. Energy Chart/Details Card ---
//   Widget _buildDetailsCard(String mainValue, List<DetailData> dataList, {required String title, required bool isExpanded, required int blockIndex, required bool isRevenueView}) {
//
//     final valueUnit = isRevenueView ? 'tk' : 'kW';
//     final mainValueColor = isRevenueView ? AppColors.primary : AppColors.primary;
//
//     // Determine the title shown in the list area
//     final listTitle = isRevenueView ? 'Data & Cost Info' : 'Energy Chart';
//
//     return Container(
//       padding: EdgeInsets.all(15.r),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: AppColors.grey),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 1. Title and Main Value Row (Only visible in Data View)
//           if (!isRevenueView)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.darkGrey,
//                       ),
//                     ),
//                     Text(
//                       '$mainValue $valueUnit',
//                       style: TextStyle(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.bold,
//                         color: mainValueColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15.h),
//               ],
//             ),
//
//           // 2. Expansion/Details Title Row
//           if (isRevenueView)
//             GestureDetector(
//               onTap: () {
//                 // Trigger the collapse/expand event for this specific block
//                 context.read<DetailViewBloc>().add(ToggleChartExpand(blockIndex));
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: isExpanded ? 8.h : 0.h),
//                 child: Row(
//                   children: [
//                     // Icon for Revenue View Title (Bar Chart)
//                     Icon(Icons.bar_chart, color: AppColors.darkGrey, size: 24.sp),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: Text(
//                         listTitle,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.darkGrey,
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       isExpanded ? Icons.keyboard_double_arrow_up_outlined : Icons.keyboard_double_arrow_down_outlined,
//                       color: AppColors.primary,
//                       size: 24.sp,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//           // 3. Collapsible List Content
//           if (isExpanded || !isRevenueView)
//             Column(
//               children: [
//                 // Add Divider only in Data View before the list items
//                 if (!isRevenueView)
//                   Divider(color: AppColors.lightGrey, height: 1.h, thickness: 1.0),
//
//                 // SizedBox(height: 10.h), // Removed as spacing is in list item
//
//                 ...dataList.map((data) => _buildDetailListItem(data, isRevenueView: isRevenueView)),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailListItem(DetailData data, {required bool isRevenueView}) {
//     // If Revenue View, Data list items don't have the coloured dot or the background container/border
//     if (isRevenueView) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: 10.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${data.title} : ${data.dataValue} (${data.percentage})',
//               style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 2.h),
//             Text(
//               'Cost ${data.title.substring(data.title.length - 1)} : ${data.costValue} ৳',
//               style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//             ),
//             if (data.title != 'Data 4') // If not the last item, add a spacer/divider
//               SizedBox(height: 8.h),
//           ],
//         ),
//       );
//     }
//
//     // Data View list item (with dot, container, and arrow)
//     return Padding(
//       padding: EdgeInsets.only(bottom: 10.h),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           border: Border.all(color: AppColors.lightGrey, width: 1.w),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Row(
//           children: [
//             // Left Indicator (Colored dot and Title)
//             Row(
//               children: [
//                 Container(
//                   width: 6.w,
//                   height: 6.w,
//                   decoration: BoxDecoration(
//                     color: data.color,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   data.title,
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.darkGrey,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: 15.w),
//
//             // Middle Data (Data and Cost)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Data: ',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
//                         ),
//                         TextSpan(
//                           text: '${data.dataValue} (${data.percentage})',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Cost: ',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
//                         ),
//                         TextSpan(
//                           text: '${data.costValue} ৳',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Right Arrow (Only visible in Data View)
//             if (!isRevenueView) // Arrow only visible in Data View
//               Icon(
//                 Icons.arrow_forward_ios,
//                 color: AppColors.grey,
//                 size: 18.sp,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

///old
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import '../../../core/constants/app_colors.dart';
// import '../bloc/detail_bloc.dart';
// import '../bloc/detail_event.dart';
// import '../bloc/detail_state.dart';
//
// class DetailViewScreen extends StatefulWidget {
//   const DetailViewScreen({super.key});
//
//   @override
//   State<DetailViewScreen> createState() => _DetailViewScreenState();
// }
//
// class _DetailViewScreenState extends State<DetailViewScreen> {
//
//   // Default date range state to hold the selected range
//   DateTimeRange _selectedDateRange = DateTimeRange(
//     start: DateTime.now().subtract(const Duration(days: 7)),
//     end: DateTime.now(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (context.mounted) {
//         context.read<DetailViewBloc>().add(LoadDetailData());
//       }
//     });
//   }
//
//   // Function to show a date range picker modal
//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: _selectedDateRange,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             primaryColor: AppColors.primary,
//             colorScheme: ColorScheme.light(primary: AppColors.primary),
//             buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != _selectedDateRange) {
//       setState(() {
//         _selectedDateRange = picked;
//       });
//       // Optionally trigger data reload after selecting new range
//       // context.read<DetailViewBloc>().add(LoadCustomDateData(picked.start, picked.end));
//     }
//   }
//
//   // Helper function to build Bloc content
//   Widget _buildBlocContent() {
//     return BlocBuilder<DetailViewBloc, DetailViewState>(
//       builder: (context, state) {
//         if (state is DetailViewLoading || state is DetailViewInitial) {
//           return Center(child: CircularProgressIndicator(color: AppColors.primary));
//         }
//
//         if (state is DetailViewLoaded) {
//           return _buildLoadedContent(context, state);
//         }
//
//         return Center(
//           child: Text('Error loading data.', style: TextStyle(color: AppColors.red)),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrey,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.darkGrey, size: 28.sp),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'SCM',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_none,
//               color: AppColors.darkGrey,
//               size: 28.sp,
//             ),
//             onPressed: () {
//               /* Handle notifications */
//             },
//           ),
//         ],
//       ),
//
//       // UPDATED BODY STRUCTURE
//       body: SafeArea(
//           child: Column( // Column is necessary to use Expanded
//             children: [
//               // Expanded for the main content area (which contains the Stack/Bloc)
//               Expanded(
//                 child: Padding(
//                     padding: EdgeInsets.only(top: 16.w), // Horizontal padding for the white container
//                     child: _buildBlocContent() // BlocBuilder inside the Expanded area
//                 ),
//               ),
//               // Placeholder for fixed bottom buttons/widgets if any
//             ],
//           )
//       ),
//     );
//   }
//
//   Widget _buildLoadedContent(BuildContext context, DetailViewLoaded state) {
//     final isCustomDate = state.activeDateType == 'Custom Date Data';
//     final isDataView = state.activeView == 'Data View';
//
//     final double toggleBarHeight = 50.h;
//     final double overlapOffset = 25.h;
//
//     // Get screen width for correctly placing the positioned toggle bar
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     return Stack(
//
//         children:[
//           // 1. Main White Container (with Top Border Radius)
//           Padding(
//             padding: EdgeInsets.only(top: overlapOffset),
//             child: Container(
//               padding: EdgeInsets.only(top: 40.h),
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: AppColors.white,
//                   border: Border.all(
//                     color: AppColors.grey
//                   ),
//                   borderRadius: BorderRadius.only(
//                     // Applied the requested border radius (12.r or 24.r, using 24.r for prominent design)
//                       topLeft: Radius.circular(24.r),
//                       topRight: Radius.circular(24.r)
//                   )
//               ),
//               child: Column(
//                   children: [
//                     Column(
//                       children: [
//                         _buildCircularChart(state.circularChartValue, state.circularChartUnit),
//
//                         SizedBox(height: 30.h),
//
//                         // 3. Date Toggle (Today / Custom) - Fixed height
//                         _buildDateToggle(context, state.activeDateType, isDataView: isDataView),
//
//                         if (isCustomDate && isDataView)
//                           _buildDateRangePicker(context),
//                       ],
//                     ),
//
//                     SizedBox(height: 20.h),
//
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: Column(
//                             children: List.generate(
//                                 state.chartBlocks.length, (index) {
//                               final block = state.chartBlocks[index];
//                               return Padding(
//                                 padding: EdgeInsets.only(bottom: 20.h),
//                                 child: _buildDetailsCard(
//                                   block.mainValue ?? '',
//                                   block.detailList,
//                                   title: block.title ?? '',
//                                   isExpanded: block.isExpanded,
//                                   blockIndex: index,
//                                   isRevenueView: !isDataView,
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//
//             ),
//           ),
//
//           Positioned(
//               //top: 0,
//               left: 16.w,
//               right: 16.w,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: _buildViewToggle(context, state.activeView),
//               )
//           )
//         ]
//     );
//   }
//
//   // --- 1. Toggle Bar (Data View / Revenue View) ---
//   Widget _buildViewToggle(BuildContext context, String activeView) {
//     // Make the toggle bar take the full horizontal space minus the padding
//     return Container(
//       // Adjusted width to be dynamic, matching the main content area width
//       width: MediaQuery.of(context).size.width - (16.w * 2),
//       height: 50.h,
//       //padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         border: Border.all(
//           color: AppColors.grey
//         ),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildToggleItem(
//             context,
//             'Data View',
//             activeView,
//             onTap: () => context.read<DetailViewBloc>().add(ToggleView('Data View')),
//           ),
//           _buildToggleItem(
//             context,
//             'Revenue View',
//             activeView,
//             onTap: () => context.read<DetailViewBloc>().add(ToggleView('Revenue View')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleItem(
//       BuildContext context, String title, String activeView, {required VoidCallback onTap}) {
//     final isActive = activeView == title;
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           // decoration: BoxDecoration(
//           //   color: isActive ? AppColors.white : Colors.transparent,
//           //   borderRadius: BorderRadius.circular(30.r),
//           //   border: isActive ? Border.all(color: AppColors.lightGrey) : null,
//           // ),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 8.w,
//                   height: 8.w,
//                   decoration: BoxDecoration(
//                     color: isActive ? AppColors.primary : AppColors.grey,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: isActive ? AppColors.primary : AppColors.grey,
//                     fontSize: 16.sp,
//                     fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- 2. Circular Indicator (fl_chart implementation) ---
//   Widget _buildCircularChart(String value, String unit) {
//     // Determine fill based on view. Revenue View (tk) uses a mock percentage.
//     double activeFill = unit == 'tk' ? 80.0 : double.tryParse(value.split('.').first) ?? 55.0;
//
//     // Ensure activeFill is within 0 to 100
//     if (activeFill < 0) activeFill = 0;
//     if (activeFill > 100) activeFill = 100;
//     double remainingFill = 100.0 - activeFill;
//
//     // Choose color dynamically (Primary for Data View, Green/similar for Revenue View)
//     final primaryColor = unit == 'tk' ? AppColors.primary : AppColors.primary; // Kept blue as per screenshot, but often revenue is green
//
//
//     return Center(
//       child: SizedBox(
//         height: 150.h,
//         width: 150.w,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             PieChart(
//               PieChartData(
//                 startDegreeOffset: 270,
//                 sectionsSpace: 0,
//                 centerSpaceRadius: 60.r,
//                 sections: [
//                   // Active Data Arc
//                   PieChartSectionData(
//                     value: activeFill,
//                     color: primaryColor,
//                     radius: 12.w,
//                     title: '',
//                     showTitle: false,
//                   ),
//                   // Background Arc
//                   PieChartSectionData(
//                     value: remainingFill,
//                     color: primaryColor.withOpacity(0.2),
//                     radius: 12.w,
//                     title: '',
//                     showTitle: false,
//                   ),
//                 ],
//               ),
//             ),
//             // The text in the center
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.darkGrey,
//                     ),
//                   ),
//                   Text(
//                     unit,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateToggle(BuildContext context, String activeDateType, {required bool isDataView}) {
//     final isCustomDate = activeDateType == 'Custom Date Data';
//
//     // NEW DESIGN: Wrap the items in a Container with rounded corners and border
//     return Row(
//       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Today Data
//         _buildDateToggleItemStyled(
//           context,
//           'Today Data',
//           activeDateType,
//           onTap: () {
//             context.read<DetailViewBloc>().add(ToggleDateType('Today Data'));
//           },
//         ),
//
//         if (isDataView)
//           _buildDateToggleItemStyled(
//             context,
//             'Custom Date Data',
//             activeDateType,
//             onTap: () {
//               context.read<DetailViewBloc>().add(ToggleDateType('Custom Date Data'));
//             },
//           ),
//
//       ],
//     );
//   }
//
//   // NEW: Styled Date Toggle Item (similar to _buildToggleItem)
//   Widget _buildDateToggleItemStyled(
//       BuildContext context, String title, String activeDateType, {required VoidCallback onTap}) {
//     final isActive = activeDateType == title;
//     return Expanded( // Use Expanded to make the buttons share space
//       child: GestureDetector(
//         onTap: onTap,
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Small indicator dot (Blue for Today, Gray/Orange for Custom - using Primary for consistency)
//               Container(
//                 width: 8.w,
//                 height: 8.w,
//                 decoration: BoxDecoration(
//                   color: isActive ? AppColors.primary : AppColors.grey,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: isActive ? AppColors.primary : AppColors.grey,
//                   fontSize: 16.sp,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateRangePicker(BuildContext context) {
//     // Format dates for display
//     final DateFormat formatter = DateFormat('dd-MM-yyyy');
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       child: Row(
//         children: [
//           Expanded(child: _buildDateInput(
//             context,
//             'From Date',
//             formatter.format(_selectedDateRange.start),
//                 () => _selectDateRange(context),
//           )),
//           SizedBox(width: 10.w),
//           Expanded(child: _buildDateInput(
//             context,
//             'To Date',
//             formatter.format(_selectedDateRange.end),
//                 () => _selectDateRange(context),
//           )),
//           SizedBox(width: 10.w),
//           // Search Button
//           Container(
//             height: 40.h,
//             width: 40.w,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.search, color: AppColors.white, size: 20.sp),
//               onPressed: () {
//                 // Trigger BLoC event to load data for the selected range
//                 context.read<DetailViewBloc>().add(LoadCustomDateData(
//                     _selectedDateRange.start,
//                     _selectedDateRange.end
//                 ));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateInput(BuildContext context, String label, String dateValue, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 40.h,
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(8.r),
//           border: Border.all(color: AppColors.grey.withOpacity(0.5)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               dateValue,
//               style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//             ),
//             Icon(Icons.date_range, color: AppColors.grey, size: 18.sp),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailsCard(String mainValue, List<DetailData> dataList, {required String title, required bool isExpanded, required int blockIndex, required bool isRevenueView}) {
//
//     final valueUnit = isRevenueView ? 'tk' : 'kW';
//     final mainValueColor = isRevenueView ? AppColors.primary : AppColors.primary;
//
//     return Container(
//       padding: EdgeInsets.all(15.r),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         border: Border.all(color: AppColors.grey),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           isRevenueView ? SizedBox.shrink():
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.darkGrey,
//                 ),
//               ),
//               Text(
//                 '$mainValue $valueUnit',
//                 style: TextStyle(
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.bold,
//                   color: mainValueColor,
//                 ),
//               ),
//             ],
//           ),
//           isRevenueView ? SizedBox.shrink(): SizedBox(height: 15.h),
//           if (isRevenueView)
//             GestureDetector(
//               onTap: () {
//                 // Trigger the collapse/expand event for this specific block
//                 context.read<DetailViewBloc>().add(ToggleChartExpand(blockIndex));
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 8.h),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Data & Cost Info', // Title for Revenue View
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.darkGrey,
//                         ),
//                       ),
//                     ),
//                     Icon(
//                       isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                       color: AppColors.primary,
//                       size: 24.sp,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//
//           if (isExpanded || !isRevenueView)
//             Column(
//               children: [
//                 ...dataList.map((data) => _buildDetailListItem(data, isRevenueView: isRevenueView)),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailListItem(DetailData data, {required bool isRevenueView}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 10.h),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           border: Border.all(color: AppColors.lightGrey, width: 1.w),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Row(
//           children: [
//             // Left Indicator (Colored dot and Title)
//             Row(
//               children: [
//                 Container(
//                   width: 6.w,
//                   height: 6.w,
//                   decoration: BoxDecoration(
//                     color: data.color,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   data.title,
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.darkGrey,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: 15.w),
//
//             // Middle Data (Data and Cost)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Data: ',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
//                         ),
//                         TextSpan(
//                           text: '${data.dataValue} (${data.percentage})',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Cost: ',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.grey),
//                         ),
//                         TextSpan(
//                           text: '${data.costValue} ৳',
//                           style: TextStyle(fontSize: 14.sp, color: AppColors.darkGrey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Right Arrow (Only visible in Data View, or use standard icon for Revenue)
//             if (!isRevenueView) // Arrow only visible in Data View
//               Icon(
//                 Icons.arrow_forward_ios,
//                 color: AppColors.grey,
//                 size: 18.sp,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
