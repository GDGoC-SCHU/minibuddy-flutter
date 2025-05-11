import 'package:dio/dio.dart';
import 'package:minibuddy/services/user/user_profile.dart';
import 'package:minibuddy/utils/api_client.dart';

Future<UserProfile> fetchUserProfile() async {
  try {
    final res = await ApiClient.instance.get('/api/user/profile');
    return UserProfile.fromJson(res.data);
  } on DioException catch (e) {
    throw Exception('[GET] 유저 정보 불러오기 실패: ${e.message}');
  }
}

Future<void> updateNickname(String newName) async {
  try {
    await ApiClient.instance.patch(
      '/api/user/profile',
      data: {'name': newName},
    );
  } on DioException catch (e) {
    throw Exception('[PATCH] 닉네임 수정 실패: ${e.message}');
  }
}

Future<void> updateBirthdate(DateTime newDate) async {
  try {
    await ApiClient.instance.patch(
      '/api/user/profile',
      data: {'birthdate': newDate.toIso8601String()},
    );
  } on DioException catch (e) {
    throw Exception('[PATCH] 생일 수정 실패: ${e.message}');
  }
}

Future<void> updateKeywords(List<String> keywords) async {
  try {
    await ApiClient.instance.patch(
      '/api/user/profile',
      data: {'keywords': keywords},
    );
  } on DioException catch (e) {
    throw Exception('[PATCH] 키워드 수정 실패: ${e.message}');
  }
}
