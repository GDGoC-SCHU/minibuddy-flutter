import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  /// Firebase 로그아웃 + 서버 로그아웃 처리
  static Future<void> logout(BuildContext context) async {
    try {
      // Firebase 로그아웃
      await FirebaseAuth.instance.signOut();

      // 서버 로그아웃 요청
      await logoutFromServer();

      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      print('로그아웃 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to log out. Please try again.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  static Future<void> logoutFromServer() async {
    try {
      String fcmToken = 'denied'; // 기본값: 권한 거부 시

      // 권한 상태 확인
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // 권한이 있을 경우에만 실제 토큰 요청
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          fcmToken = token;
        }
      }

      await ApiClient.instance.post('/api/auth/logout', data: {
        'fcm-token': fcmToken,
      });

      print('서버 로그아웃 전송됨 (FCM: $fcmToken)');
    } catch (e) {
      print('서버 로그아웃 중 오류: $e');
      rethrow;
    }
  }
}
