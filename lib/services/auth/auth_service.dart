import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/utils/api_client.dart';

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

  /// 서버 로그아웃만 따로 (회원탈퇴 시에도 사용)
  static Future<void> logoutFromServer() async {
    await ApiClient.instance.post('/api/auth/logout', data: {
      'fcmToken': 'mock-fcm-token', // TODO: 실제 토큰으로 교체
    });
  }
}
