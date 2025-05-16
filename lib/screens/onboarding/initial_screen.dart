import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/auth/firebase_auth_provider.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
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
