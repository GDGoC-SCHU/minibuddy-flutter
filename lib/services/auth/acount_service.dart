import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/auth/auth_service.dart';
import 'package:minibuddy/utils/api_client.dart';

class AccountService {
  /// 회원탈퇴 처리: Firebase 로그아웃 → 서버 로그아웃 → 탈퇴 요청
  static Future<void> deleteUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await AuthService.logoutFromServer();

      final response = await ApiClient.instance.post('/api/user/delete');

      final result = response.data['result'];
      final data = response.data['data'];

      print('회원탈퇴 응답: $result / $data');

      if (result['resultCode'] == 200 && data == 'user deleted successfully') {
        if (context.mounted) {
          context.go('/');
        }
      } else {
        throw Exception('Account deletion failed');
      }
    } catch (e) {
      print('회원탈퇴 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to delete account. Please try again.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }
}
