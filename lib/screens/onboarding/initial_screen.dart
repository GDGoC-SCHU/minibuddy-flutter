import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // 콘텐츠
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  // 버니 이미지
                  Image.asset(
                    'assets/images/bunny.png',
                    width: 250.w,
                  ),
                  SizedBox(height: 38.h),
                  // 로고
                  Image.asset(
                    'assets/images/logo.png',
                    width: 350.w,
                  ),
                  SizedBox(height: 5.h),
                  // 구글 로그인 버튼 (→ 닉네임 입력 화면으로 이동)
                  GestureDetector(
                    onTap: () {
                      context.push('/onboarding/nickname');
                    },
                    child: SizedBox(
                      width: 290.w,
                      child: Image.asset(
                        'assets/images/google_signin_button.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
