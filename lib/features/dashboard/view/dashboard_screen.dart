import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:scub/core/constants/app_colors.dart'; // Using AppColor defined below
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../details/view/details_view_screen.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class SourceItem {}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // UI State Variables
  String _activeTab = 'Summary'; // Summary, SLD, Data
  String _activeToggle = 'Source'; // Source, Load

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure BLoC is available before accessing it
      if (context.mounted) {
         context.read<DashboardBloc>().add(LoadDashboardData());
      }
    });
  }

  // --- Main Build Method (UPDATED FOR INNER SCROLLABILITY) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        //elevation: 6,
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
              /* Handle notifications */
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              // Outer Expanded wrapping the main content area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.grey, width: 1.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    // Inner Column
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            children: [
                              // Content changes based on the active tab
                              if (_activeTab == 'Summary') ...[
                                // _buildBlocContent() now returns an Expanded widget
                                _buildBlocContent(),
                              ]
                              // Use Expanded for placeholder content to fill space
                              else if (_activeTab == 'SLD')
                                Expanded(
                                  child: _buildPlaceholderContent(
                                    'SLD View',
                                    AppAssets.noData,
                                  ),
                                )

                              // Use Expanded for placeholder content to fill space
                              else if (_activeTab == 'Data')
                                  Expanded(
                                    child: _buildPlaceholderContent(
                                      'Raw Data',
                                      AppAssets.noData,
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

              // The shortcut buttons Grid is now at the bottom (fixed).
              SizedBox(height: 16.h),
              _buildShortcutButtonsGrid(),
              //SizedBox(height: 10.h), // Extra space at the bottom for safety
            ],
          ),
        ),
      ),
    );
  }

  // --- 2. Tab Bar Widget (No change) ---
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('Summary'),
          _buildTabItem('SLD'),
          _buildTabItem('Data'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title) {
    // ... (unchanged)
    final isActive = _activeTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = title;
            if (title == 'Summary') {
              _activeToggle = 'Source'; // Default back to Source on Summary
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(11.r),
              topRight: Radius.circular(11.r),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.darkGrey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlocContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {

        List<SourceItem> mockSources = [];
        double mockTodayTotal = 5530.0;

        if (state is DashboardLoading) {
          // Loading state must be wrapped in Expanded
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
          // Empty state must be wrapped in Expanded
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Center(
                child: Image.asset(
                AppAssets.noData,
                width: 300.w,
                height: 300.h,
                fit: BoxFit.contain,
              ),),
            ),
          );
        }

        return Flexible(
          fit: FlexFit.loose, // This is key for fixing the error in nested Columns
          child: Column(
            children: [
              // 1. FIXED HEIGHT HEADER (Title & Ring Chart) - Takes intrinsic height
              Column(
                children: [
                  SizedBox(height: 5.h),
                  _buildElectricityTitle(),
                  SizedBox(height:10.h),// Fixed height
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.grey, width: 0.6.w),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildRingChart(mockTodayTotal / 1000),
                  SizedBox(height: 16.h),
                  _buildSourceLoadToggle(),
                  SizedBox(height:5.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.grey, width: 0.6.w),
                    ),
                  ),
                  SizedBox(height:8.h),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      // List changes based on active toggle
                      if (_activeToggle == 'Source')
                        _buildSourcesList(mockSources)
                      else
                      // FIX: Corrected list logic to ensure only one list is built.
                        _buildLoadsList(mockSources),

                      SizedBox(height: 10.h), // Padding at the bottom of the scroll view
                    ],
                  ),
                ),
              ),
            ],
          ),
        );


      },
    );
  }

  Widget _buildElectricityTitle() {
    // ... (unchanged)
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

  Widget _buildRingChart(double totalPower) {
    // ... (unchanged)
    return Center(
      child: Container(
        height: 140.h,
        width: 140.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.deepBlue, width: 15.w),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Power',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.darkGrey.withOpacity(0.7),
                ),
              ),
              Text(
                '5.53 kW',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Source/Load Toggle (No change) ---
  Widget _buildSourceLoadToggle() {
    // ... (unchanged)
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(30.r), // Highly rounded
      ),
      child: Row(
        children: [
          _buildToggleItemButton('Source'),
          SizedBox(width: 8.w),
          _buildToggleItemButton('Load'),
        ],
      ),
    );
  }

  Widget _buildToggleItemButton(String title) {
    // ... (unchanged)
    final isActive = _activeToggle == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeToggle = title;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.darkGrey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- List Views (No change) ---
  Widget _buildSourcesList(List<SourceItem> sources) {
    // ... (unchanged)
    return Column(
      children: [
        _buildSourceListItem(
          icon: AppAssets.solarCell,
          title: 'Data View',
          status: 'Active',
          iconColor: AppColors.primary,
          badgeColor: AppColors.purple,
        ),
        SizedBox(height: 10.h),
        _buildSourceListItem(
          icon: AppAssets.asset2,
          title: 'Data Type 2',
          status: 'Active',
          iconColor: AppColors.orange,
          badgeColor: AppColors.primary,
        ),
        SizedBox(height: 10.h),
        _buildSourceListItem(
          icon: AppAssets.power,
          title: 'Data Type 3',
          status: 'Inactive',
          iconColor: AppColors.red,
          badgeColor: AppColors.red,
        ),
      ],
    );
  }

  Widget _buildLoadsList(List<SourceItem> sources) {
    // ... (unchanged)
    return Column(
      children: [
        _buildSourceListItem(
          icon: AppAssets.solarCell,
          title: 'Motor Load 1',
          status: 'Active',
          iconColor: Colors.red,
          badgeColor: AppColors.purple,
        ),
        SizedBox(height: 10.h),
        _buildSourceListItem(
          icon: AppAssets.power,
          title: 'Lighting Circuit',
          status: 'Active',
          iconColor: Colors.orange,
          badgeColor: AppColors.primary,
        ),
        SizedBox(height: 10.h),
        _buildSourceListItem(
          icon: AppAssets.asset2,
          title: 'AC Unit 3',
          status: 'Inactive',
          iconColor: AppColors.grey,
          badgeColor: AppColors.red,
        ),
      ],
    );
  }

  Widget _buildSourceListItem({
    //required IconData icon,
    required String icon,
    required String title,
    required String status,
    required Color iconColor,
    required Color badgeColor,
  }) {
    // ... (unchanged)
    const String data1 = '55505.63';
    const String data2 = '58805.63';
    final bool isActive = status == 'Active';

    return InkWell(
      onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetailViewScreen(),
            ),
          );

      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.grey, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isActive ? '(Active)' : '(Inactive)',
                        style: TextStyle(
                          color: isActive ? AppColors.primary : AppColors.red,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Data 1 : $data1',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Data 2 : $data2',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkGrey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkGrey.withOpacity(0.5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  // --- Shortcut Buttons Grid (No change) ---
  Widget _buildShortcutButtonsGrid() {
    // ... (unchanged)
    final List<Map<String, dynamic>> shortcuts = [
      {
        'title': 'Analysis Pro',
        'icon': AppAssets.chart,
      },
      {
        'title': 'G. Generator',
        'icon':AppAssets.generator,
      },
      {
        'title': 'Plant Summery',
        'icon': AppAssets.charge,
      },
      {
        'title': 'Natural Gas',
        'icon': AppAssets.fire,
      },
      {
        'title': 'D. Generator',
        'icon': AppAssets.generator,
      },
      {
        'title': 'Water Process',
        'icon': AppAssets.waterProcess,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      //padding: EdgeInsets.symmetric(horizontal: 10.w),
      itemCount: shortcuts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemBuilder: (context, index) {
        final item = shortcuts[index];
        return _buildShortcutButton(
          item['title'] as String,
          item['icon'] as String,
        );
      },
    );
  }

  Widget _buildShortcutButton(String title, String icon) {
    // ... (unchanged)
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.grey,width: 0.6.w),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
        child: InkWell(
          onTap: () {
            // Placeholder functionality
          },
          borderRadius: BorderRadius.circular(15.r),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                icon,
                width: 20.w,
                height: 20.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  //fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),

    );
  }

  // Placeholder content for SLD/Data tabs
  Widget _buildPlaceholderContent(String title, String icon) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 0.w),
      decoration: BoxDecoration(
        //color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10.h),
          Text(
            textAlign: TextAlign.center,
            '$title Content is under development.',
            style: TextStyle(fontSize: 18.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // ... (unchanged)
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 100.sp,
          color: AppColors.grey.withOpacity(0.5),
        ),
        SizedBox(height: 20.h),
        Text(
          'No data to show, please wait.',
          style: TextStyle(fontSize: 18.sp, color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// // import 'package:scub/core/constants/app_colors.dart'; // Using AppColor defined below
// import '../../../core/constants/app_colors.dart';
// import '../bloc/dashboard_bloc.dart';
// import '../bloc/dashboard_event.dart';
// import '../bloc/dashboard_state.dart';
//
// class SourceItem {}
//
// class AppColor {
//   static const Color primary = Color(
//     0xFF0D47A1,
//   ); // Deep Blue (used for active states)
//   static const Color white = Colors.white;
//   static const Color darkGrey = Color(0xFF424242);
//   static const Color grey = Color(0xFF757575);
//   static const Color lightGrey = Color(
//     0xFFEEEEEE,
//   ); // Light background for tab bar
//   static const Color orange = Color(0xFFFF9800); // Used for battery/generator
//   static const Color red = Color(0xFFE53935); // Used for inactive/gas
//   static const Color blue = Color(0xFF1E88E5); // Used for solar/analysis
//   static const Color purple = Color(0xFF8E24AA); // Used for Active badge 1
//   static const Color brown = Color(0xFF795548);
//   static const Color yellow = Color(0xFFFFEB3B);
//   static const Color cyan = Color(0xFF00BCD4);
// }
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   // UI State Variables
//   String _activeTab = 'Summary'; // Summary, SLD, Data
//   String _activeToggle = 'Source'; // Source, Load
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Ensure BLoC is available before accessing it
//       if (context.mounted) {
//         // NOTE: Context read is commented out as BLoC definition is missing,
//         // but kept the structure as requested.
//         // context.read<DashboardBloc>().add(LoadDashboardData());
//       }
//     });
//   }
//
//   // --- Main Build Method (FIXED CONSTRAINTS) ---
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // FIX: Use AppColor.white as AppColors is not fully defined
//         backgroundColor: AppColor.white,
//         title: Text(
//           'SCM',
//           style: TextStyle(
//             color: AppColor.darkGrey,
//             fontSize: 22.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.notifications_none,
//               color: AppColor.darkGrey,
//               size: 28.sp,
//             ),
//             onPressed: () {
//               /* Handle notifications */
//             },
//           ),
//         ],
//       ),
//       // FIX: Use AppColor.lightGrey
//       backgroundColor: AppColors.lightGrey,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.r),
//           child: Column(
//             children: [
//               // Outer Expanded wrapping the main content area
//               Expanded(
//                 child: Container(
//                   //padding: EdgeInsets.all(6.r),
//                   decoration: BoxDecoration(
//                     // FIX: Use AppColor.white
//                     color: AppColor.white,
//                     border: Border.all(color: AppColors.grey, width: 2.w),
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//                   child: Column(
//                     // Inner Column
//                     children: [
//                       _buildTabBar(), // Fixed height/intrinsic widget
//
//                       Expanded(
//                         child: SingleChildScrollView(
//                           // Now the direct child of Expanded
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10.w),
//                             child: Column(
//                               children: [
//                                 //SizedBox(height: 10.h),
//
//                                 // Content changes based on the active tab
//                                 if (_activeTab == 'Summary') ...[
//                                   _buildBlocContent(),
//                                 ]
//                                 // Use else if for mutually exclusive content
//                                 else if (_activeTab == 'SLD')
//                                   _buildPlaceholderContent(
//                                     'SLD View',
//                                     Icons.schema,
//                                   ),
//
//                                 if (_activeTab ==
//                                     'Data') // Fixed: Should be else if/else
//                                   _buildPlaceholderContent(
//                                     'Raw Data',
//                                     Icons.table_chart,
//                                   ),
//
//                                 SizedBox(height: 20.h),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // The shortcut buttons Grid is now at the bottom (fixed).
//               SizedBox(height: 20.h),
//               _buildShortcutButtonsGrid(),
//               SizedBox(height: 20.h), // Extra space at the bottom for safety
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- 2. Tab Bar Widget (Same as image) ---
//   Widget _buildTabBar() {
//     return Container(
//       //margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
//       //padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         //color: AppColor.lightGrey,
//         //borderRadius: BorderRadius.circular(10.r),
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.grey
//           )
//         )
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildTabItem('Summary'),
//           _buildTabItem('SLD'),
//           _buildTabItem('Data'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabItem(String title) {
//     final isActive = _activeTab == title;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _activeTab = title;
//             if (title == 'Summary') {
//               _activeToggle = 'Source'; // Default back to Source on Summary
//             }
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           decoration: BoxDecoration(
//             color: isActive ? AppColor.blue : Colors.transparent,
//             // Active blue tab
//             borderRadius: BorderRadius.only(
//               //bottomRight: Radius.circular(12.r),
//               topLeft: Radius.circular(12.r),
//               topRight: Radius.circular(12.r),
//             ),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: isActive ? AppColor.white : AppColor.darkGrey,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- 3. BLoC Content Widget (Ring Chart, Source List) ---
//   Widget _buildBlocContent() {
//     return BlocBuilder<DashboardBloc, DashboardState>(
//       builder: (context, state) {
//         if (state is DashboardLoading) {
//           return Padding(
//             padding: EdgeInsets.only(top: 50.h),
//             child: Center(
//               child: CircularProgressIndicator(color: AppColor.primary),
//             ),
//           );
//         }
//
//         List<SourceItem> mockSources = [];
//         double mockTodayTotal = 5530.0;
//
//         // if (state is DashboardLoaded) {
//         //   mockSources = state.sources;
//         //   mockTodayTotal = state.todayTotal.toDouble();
//         // }
//
//         // Since we cannot run the BLoC, we assume data is loaded for layout testing
//         // if (state is DashboardLoaded || true) {
//         return Column(
//           children: [
//             SizedBox(height: 5.h),
//             _buildElectricityTitle(),
//             SizedBox(height: 15.h),
//             // Ring Chart is here
//             _buildRingChart(mockTodayTotal / 1000),
//             SizedBox(height: 20.h),
//             _buildSourceLoadToggle(),
//             SizedBox(height: 10.h),
//
//             // List changes based on active toggle
//             if (_activeToggle == 'Source') _buildSourcesList(mockSources),
//
//             // FIX: Use else to ensure only one list is built.
//             _buildLoadsList(mockSources),
//           ],
//         );
//         // }
//
//         if (state is DashboardEmpty) {
//           return Padding(
//             padding: EdgeInsets.only(top: 50.h),
//             child: Center(child: _buildEmptyState()),
//           );
//         }
//         return Container();
//       },
//     );
//   }
//
//   Widget _buildElectricityTitle() {
//     return Align(
//       alignment: Alignment.center,
//       child: Padding(
//         padding: EdgeInsets.only(left: 10.w),
//         child: Text(
//           'Electricity',
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w500,
//             color: AppColors.grey,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRingChart(double totalPower) {
//     return Center(
//       child: Container(
//         height: 180.h,
//         width: 180.w,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColor.blue, width: 15.w),
//           // Primary blue ring
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Total Power',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: AppColor.darkGrey.withOpacity(0.7),
//                 ),
//               ),
//               Text(
//                 // Use hardcoded value from image for perfect match
//                 '5.53 kW',
//                 // '${totalPower.toStringAsFixed(2)} kW',
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.primary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Source/Load Toggle (Same as image) ---
//   Widget _buildSourceLoadToggle() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10.w),
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: AppColor.lightGrey,
//         borderRadius: BorderRadius.circular(30.r), // Highly rounded
//       ),
//       child: Row(
//         children: [
//           _buildToggleItemButton('Source'),
//           SizedBox(width: 8.w),
//           _buildToggleItemButton('Load'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleItemButton(String title) {
//     final isActive = _activeToggle == title;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             _activeToggle = title;
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           decoration: BoxDecoration(
//             color: isActive ? AppColor.blue : AppColor.lightGrey,
//             // Active blue button
//             borderRadius: BorderRadius.circular(30.r),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: isActive ? AppColor.white : AppColor.darkGrey,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- List View for Sources (Same as image) ---
//   Widget _buildSourcesList(List<SourceItem> sources) {
//     return Column(
//       children: [
//         // Source 1: Data View (Solar, Purple/Amber Active Badge)
//         _buildSourceListItem(
//           icon: Icons.solar_power_outlined,
//           title: 'Data View',
//           status: 'Active',
//           iconColor: AppColor.blue,
//           badgeColor: AppColor.purple,
//         ),
//         SizedBox(height: 10.h),
//
//         // Source 2: Data Type 2 (Battery, Blue Active Badge)
//         _buildSourceListItem(
//           icon: Icons.battery_charging_full,
//           title: 'Data Type 2',
//           status: 'Active',
//           iconColor: AppColor.orange,
//           badgeColor: AppColor.blue,
//         ),
//         SizedBox(height: 10.h),
//
//         // Source 3: Data Type 3 (Turbine/Construction, Red Inactive Badge)
//         _buildSourceListItem(
//           icon: Icons.power_outlined,
//           // Closer to the image's turbine icon
//           title: 'Data Type 3',
//           status: 'Inactive',
//           iconColor: AppColor.red,
//           badgeColor: AppColor.red, // Inactive badge is red/grey
//         ),
//       ],
//     );
//   }
//
//   // --- List View for Loads (Example data if Load is selected) ---
//   Widget _buildLoadsList(List<SourceItem> sources) {
//     return Column(
//       children: [
//         _buildSourceListItem(
//           icon: Icons.factory,
//           title: 'Motor Load 1',
//           status: 'Active',
//           iconColor: Colors.red,
//           badgeColor: AppColor.purple,
//         ),
//         SizedBox(height: 10.h),
//         _buildSourceListItem(
//           icon: Icons.lightbulb,
//           title: 'Lighting Circuit',
//           status: 'Active',
//           iconColor: Colors.orange,
//           badgeColor: AppColor.blue,
//         ),
//         SizedBox(height: 10.h),
//         _buildSourceListItem(
//           icon: Icons.thermostat,
//           title: 'AC Unit 3',
//           status: 'Inactive',
//           iconColor: AppColor.grey,
//           badgeColor: AppColor.red,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSourceListItem({
//     required IconData icon,
//     required String title,
//     required String status,
//     required Color iconColor,
//     required Color badgeColor,
//   }) {
//     // Hardcoding data values as per image
//     const String data1 = '55505.63';
//     const String data2 = '58805.63';
//
//     final bool isActive = status == 'Active';
//
//     return Container(
//       padding: EdgeInsets.all(15.w),
//       margin: EdgeInsets.symmetric(horizontal: 0.w),
//       // Margin handled by parent padding
//       // Margin to align with the rest of the content
//       decoration: BoxDecoration(
//         color: AppColor.white,
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(color: AppColor.lightGrey, width: 1.w),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Icon/Indicator
//           Icon(icon, color: iconColor, size: 30.sp),
//           SizedBox(width: 15.w),
//
//           // Title and Data
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.darkGrey,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 6.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isActive ? badgeColor : AppColor.red,
//                         borderRadius: BorderRadius.circular(5.r),
//                       ),
//                       child: Text(
//                         isActive ? 'Active' : 'Inactive',
//                         style: TextStyle(
//                           color: AppColor.white,
//                           fontSize: 10.sp,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   'Data 1 : $data1',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColor.darkGrey.withOpacity(0.7),
//                   ),
//                 ),
//                 Text(
//                   'Data 2 : $data2',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColor.darkGrey.withOpacity(0.7),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Arrow (Same as image)
//           Icon(
//             Icons.arrow_forward_ios,
//             color: AppColor.darkGrey.withOpacity(0.5),
//             size: 20.sp,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- Shortcut Buttons Grid (Same as image) ---
//   Widget _buildShortcutButtonsGrid() {
//     final List<Map<String, dynamic>> shortcuts = [
//       {
//         'title': 'Analysis Pro',
//         'icon': Icons.trending_up,
//         'color': AppColor.blue,
//       },
//       {
//         'title': 'G. Generator',
//         'icon': Icons.generating_tokens,
//         'color': AppColor.orange,
//       },
//       {
//         'title': 'Plant Summery',
//         'icon': Icons.summarize,
//         'color': AppColor.brown,
//       },
//       {
//         'title': 'Natural Gas',
//         'icon': Icons.local_gas_station,
//         'color': AppColor.red,
//       },
//       {
//         'title': 'D. Generator',
//         'icon': Icons.electric_bolt,
//         'color': AppColor.yellow,
//       },
//       {
//         'title': 'Water Process',
//         'icon': Icons.water_drop,
//         'color': AppColor.cyan,
//       },
//     ];
//
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       itemCount: shortcuts.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.1,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h,
//       ),
//       itemBuilder: (context, index) {
//         final item = shortcuts[index];
//         return _buildShortcutButton(
//           item['title'] as String,
//           item['icon'] as IconData,
//           item['color'] as Color,
//         );
//       },
//     );
//   }
//
//   Widget _buildShortcutButton(String title, IconData icon, Color color) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColor.white,
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1), // Slightly stronger shadow
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             // Placeholder functionality
//           },
//           borderRadius: BorderRadius.circular(15.r),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 35.sp, color: color),
//               SizedBox(height: 8.h),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColor.darkGrey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Placeholder content for SLD/Data tabs
//   Widget _buildPlaceholderContent(String title, IconData icon) {
//     return Container(
//       height: 300.h,
//       margin: EdgeInsets.symmetric(horizontal: 0.w),
//       // Margin handled by parent padding
//       decoration: BoxDecoration(
//         color: AppColor.lightGrey.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(15.r),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 80.sp, color: AppColor.grey),
//             SizedBox(height: 10.h),
//             Text(
//               '$title Content is under development.',
//               style: TextStyle(fontSize: 18.sp, color: AppColor.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.search_off,
//           size: 100.sp,
//           color: AppColor.grey.withOpacity(0.5),
//         ),
//         SizedBox(height: 20.h),
//         Text(
//           'No data to show, please wait.',
//           style: TextStyle(fontSize: 18.sp, color: AppColor.grey),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
// }
//
//
