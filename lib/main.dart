import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scub/features/details/bloc/detail_bloc.dart';
import 'package:scub/features/details/view/details_view_screen.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/view/login_screen.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/view/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppWrapper());
}

/// ScreenUtil Wrapper
class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // UI design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),

        BlocProvider(
          create: (context) => DashboardBloc(),
        ),

        BlocProvider(
          create: (context) => DetailViewBloc(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SCUBE',
        theme: AppTheme.lightTheme,

        home: const LoginScreen(),
        //home: const DashboardScreen(),
        //home: const DetailViewScreen(),

        routes: {
          // '/dashboard': (_) => const DashboardScreen(),
        },
      ),
    );
  }
}
