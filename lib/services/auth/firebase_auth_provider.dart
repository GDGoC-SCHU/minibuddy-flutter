import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';
import 'package:minibuddy/utils/web_only_utils.dart';

enum AuthStatus {
  loginSuccess,
  registerSuccess,
  loginFailed,
}

class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<(AuthStatus, User?)?> handleRedirectResult([String? fcmToken]) async {
    try {
      final result = await FirebaseAuth.instance.getRedirectResult();
      final user = result.user;

      if (user != null) {
        print('Redirect 로그인 완료: ${user.email}');
        OnboardingState().uid = user.uid;

        final isNewUser = result.additionalUserInfo?.isNewUser ?? false;

        // FCM 토큰 전송도 여기서
        if (!isNewUser) {
          final rawToken = fcmToken ?? OnboardingState().fcmToken;
          final tokenToSend = (rawToken != null && rawToken.trim().isNotEmpty)
              ? rawToken.trim()
              : 'unavailable';

          final response = await ApiClient.instance.post(
            '/api/user/fcm-update',
            data: {
              'fcm_token': tokenToSend,
            },
          );
          print('FCM 업데이트 응답 (redirect): ${response.data}');
        }

        return (
          isNewUser ? AuthStatus.registerSuccess : AuthStatus.loginSuccess,
          user
        );
      }

      return null;
    } catch (e, stack) {
      print('❌ Redirect 결과 처리 중 오류: $e');
      print(stack);
      return (AuthStatus.loginFailed, null);
    }
  }

  Future<(AuthStatus, User?)> loginWithGoogle([String? fcmToken]) async {
    try {
      if (kIsWeb && isIosWeb()) {
        print('iOS 웹 → redirect으로');
        final googleProvider = GoogleAuthProvider();
        await _auth.signInWithRedirect(googleProvider);
        return (AuthStatus.loginFailed, null); // redirect 이후 다시 진입 시 처리됨
      }

      print('🔵 GoogleSignIn 시도');
      final googleUser = await GoogleSignIn().signIn();
      print('🔵 googleUser: $googleUser');

      if (googleUser == null) {
        print('🔵 유저가 로그인 취소함');
        return (AuthStatus.loginFailed, null);
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Firebase Web에서 로그인 복구가 지연될 수 있으므로 명시적으로 기다림
      if (user == null || user.uid.isEmpty) {
        print('UID 복구 대기 중...');
        user = await _auth.authStateChanges().firstWhere((u) => u != null);
        print('UID 복구 완료: ${user!.uid}');
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      OnboardingState().uid = user!.uid;

      if (user != null) {
        OnboardingState().uid = user.uid;

        if (!isNewUser) {
          final rawToken = fcmToken ?? OnboardingState().fcmToken;
          final tokenToSend = (rawToken != null && rawToken.trim().isNotEmpty)
              ? rawToken.trim()
              : 'unavailable';

          final response = await ApiClient.instance.post(
            '/api/user/fcm-update',
            data: {
              'fcm_token': tokenToSend.isNotEmpty ? tokenToSend : 'unavailable',
            },
          );
          print('FCM 업데이트 응답: ${response.data}');
        }

        return (
          isNewUser ? AuthStatus.registerSuccess : AuthStatus.loginSuccess,
          user
        );
      } else {
        print('user가 null입니다. 로그인 실패로 처리합니다.');
        return (AuthStatus.loginFailed, null);
      }
    } catch (e, stack) {
      print('구글 로그인 오류: $e');
      print('스택: $stack');
      return (AuthStatus.loginFailed, null);
    }
  }
}
