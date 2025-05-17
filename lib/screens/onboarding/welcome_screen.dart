import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: SingleChildScrollView(
                // 화면 넘침 방지
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 48.h,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(), // 위 여백 조절
                        Image.asset(
                          'assets/images/bunny.png',
                          width: 250.w,
                          height: 250.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 60.h),
                        Flexible(
                          child: Text(
                            'Welcome!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Pretendard',
                              color: const Color.fromARGB(255, 59, 59, 59),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Flexible(
                          child: Text(
                            'We appreciate you sharing your info.\nYou’re now ready for personalized chats.\nTap the mic whenever you’re ready to start.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                              color: const Color.fromARGB(255, 111, 110, 110),
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            child: const Text('Start'),
                          ),
                        ),
                        const Spacer(), // 아래 여백 조절
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
