import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.grey[800]!,
        onPrimary: Colors.white,
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 마스코트 이미지 (있다면)
              Image.asset(
                'assets/images/bunny.png',
                width: 200.w,
                height: 200.h,
              ),
              SizedBox(height: 40.h),
              Text(
                'Welcome to MiniBuddy!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "You're all set.\nLet's start our journey together.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 60.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
