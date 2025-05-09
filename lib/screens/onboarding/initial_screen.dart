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
              'assets/onboarding/background.png',
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
                  // 버니 이미지
                  Image.asset(
                    'assets/onboarding/bunny.png',
                    width: 270.w,
                    height: 270.h,
                  ),
                  SizedBox(height: 80.h),
                  // 부제
                  Text(
                    'Your tiny companion, always by your side',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Pretendard',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  // 로고
                  Image.asset(
                    'assets/onboarding/logo_w.png',
                    width: 300.w,
                  ),
                  SizedBox(height: 20.h),
                  // 설명 텍스트
                  Text(
                    "MiniBuddy listens, whenever you need",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 60.h),
                  // 구글 로그인 버튼 (→ 닉네임 입력 화면으로 이동)
                  GestureDetector(
                    onTap: () {
                      context.push('/onboarding/nickname');
                    },
                    child: SizedBox(
                      width: 250.w,
                      height: 55.h,
                      child: Image.asset(
                        'assets/onboarding/google_signin_button.png',
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
