import 'package:dio/dio.dart';
import 'package:minibuddy/config.dart';

class OnboardingApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> signup(Map<String, dynamic> data) async {
    print('📤 요청 보냄 → /api/auth/signup');
    print('📦 요청 내용:\n$data');

    final response = await _dio.post('/api/auth/signup', data: data);

    print('📥 응답 받음 ← /api/auth/signup');
    print('📬 응답 상태 코드: ${response.statusCode}');
    print('📬 응답 데이터:\n${response.data}');

    return response;
  }
}
