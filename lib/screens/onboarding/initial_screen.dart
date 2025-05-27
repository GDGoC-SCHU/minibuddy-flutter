import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/auth/firebase_auth_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:minibuddy/services/fcm/fcm_service.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    print('🔵 로그인 요청');
    // 웹 플랫폼일 경우 먼저 권한 요청
    if (kIsWeb) {
      final settings = await FirebaseMessaging.instance.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('웹 알림 권한 허용됨');
        await initFCM(); // FCM 토큰 발급 + onMessage 등록
      } else {
        print('웹 알림 권한 거부됨');
      }
    }

    final (status, user) = await FirebaseAuthProvider().loginWithGoogle();

    if (status == AuthStatus.registerSuccess) {
      context.go('/onboarding/nickname');
    } else if (status == AuthStatus.loginSuccess) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log in. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //iOS 웹 리디렉션 결과 처리
    Future.microtask(() async {
      print('🔵 Redirect 처리 진입');

      if (!kIsWeb) return;

      final redirectResult =
          await FirebaseAuthProvider().handleRedirectResult();
      print('🔵 Redirect 결과: $redirectResult');

      print('🔵 Redirect 사용자 있음, 상태: ${redirectResult?.$1}');
      if (redirectResult != null) {
        final (status, user) = redirectResult;

        if (status == AuthStatus.registerSuccess) {
          context.go('/onboarding/nickname');
        } else if (status == AuthStatus.loginSuccess) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Redirect 로그인 실패')),
          );
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Image.asset(
                    'assets/images/bunny.png',
                    width: 250.w,
                  ),
                  SizedBox(height: 38.h),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 350.w,
                  ),
                  SizedBox(height: 5.h),
                  GestureDetector(
                    onTap: () => _handleGoogleLogin(context),
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
