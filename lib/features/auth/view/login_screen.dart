import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'admin');
  final TextEditingController _passwordController = TextEditingController(text: '1234');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginSubmitted() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login Successful! Welcome.')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },

          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // FIX: Min height set to full screen height to prevent blue bleed
                minHeight: 1.0.sh,
              ),
              child: Column(
                // FIX: Distributes space to push the form container to the bottom edge
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  _buildLoginForm()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Header Widget ---
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        // Removed unnecessary padding calculation (SafeArea handles top padding now)
        top: 80.h,
        //bottom: AppSpacing.h8,
        left: 30.w,
        right: 30.w,
      ),
      color: AppColors.primary,
      child: Column(
        children: [
          // Using a Builder with fallback for AppAssets.logo
          Builder(
            builder: (context) {
              try {
                return Image.asset(
                  AppAssets.asset1,
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.contain,
                );
              } catch (e) {
                // Fallback Icon
                return Icon(
                  Icons.speed_outlined,
                  color: AppColors.white,
                  size: 80.sp,
                );
              }
            },
          ),
          SizedBox(height: AppSpacing.h8),
          Text(
            'SCUBE',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Control & Monitoring System',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Form Container & Content ---
  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      // Consistent padding
      padding: EdgeInsets.only(top: 20.h, right: 24.w, left: 24.w, bottom: 80.h),
      child: Form(
        key: _formKey,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.h28),

            // Form Fields (Reusable functions)
            _buildUsernameField(),
            SizedBox(height: AppSpacing.h16),
            _buildPasswordField(),
            _buildForgotPasswordLink(),
            SizedBox(height: AppSpacing.h20),

            // Login Button (Reusable function)
            _buildLoginButton(),

            SizedBox(height: AppSpacing.h20),

            // Register Link (Reusable function)
            _buildRegisterLink(),
          ],
        ),
      ),
    );
  }

  // --- Reusable Input Decoration Factory ---
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.primary, width: 2.w), // Better visual feedback on focus
      ),
    );
  }

  // --- Reusable Username Field ---
  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: _buildInputDecoration('Username'),
      keyboardType: TextInputType.text,
      validator: (value) => (value == null || value.isEmpty) ? 'Enter your username' : null,
    );
  }

  // --- Reusable Password Field ---
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: _buildInputDecoration('Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: 22.sp,
            color: AppColors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Enter your password' : null,
    );
  }

  // --- Reusable Forgot Password Link ---
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot password?',
          style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
        ),
      ),
    );
  }

  // --- Reusable Login Button ---
  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : _onLoginSubmitted,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child:
          isLoading
              ? SizedBox(
            height: 24.sp,
            width: 24.sp,
            child: const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            'Login',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // --- Reusable Register Link ---
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'Register Now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

