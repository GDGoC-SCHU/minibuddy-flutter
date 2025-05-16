import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/utils/api_client.dart';

class AuthService {
  static Future<void> logout(BuildContext context) async {
    try {
      // Firebase Google 로그아웃
      await FirebaseAuth.instance.signOut();

      final response = await ApiClient.instance.post('/api/auth/logout', data: {
        'fcmToken': 'mock-fcm-token', // 추후 실제 FCM 토큰으로 교체
      });

      final result = response.data['result'];
      final data = response.data['data'];

      // ✅ 서버 응답 기준: resultCode == 200 && data == 'user deleted successfully'
      if (result['resultCode'] == 200 && data == 'user deleted successfully') {
        if (context.mounted) {
          context.go('/');
        }
      } else {
        throw Exception('Logout failed');
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
}
