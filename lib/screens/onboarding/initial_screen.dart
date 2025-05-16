import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        context.go('/onboarding/nickname');
      } else {
        context.go('/home');
      }
    } catch (e) {
      print('로그인 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
