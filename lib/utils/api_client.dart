import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minibuddy/config.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {'Content-Type': 'application/json'},
    ),
  )
    // ① 토큰·커스텀 헤더 주입용 Interceptor
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1) /api/auth/signup 는 그냥 통과
          if (options.path.contains('/api/auth/signup')) {
            return handler.next(options);
          }

          // 2) Firebase 토큰 가져오기
          final user = FirebaseAuth.instance.currentUser;
          final token = await user?.getIdToken(true); // 강제 refresh

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // 3) 상황별 커스텀 헤더
          //    - extra['chatRequest'] == true 로 표시해 두었다고 가정
          if (options.extra['chatRequest'] == true) {
            options.headers['X-Chat-Request-Type'] = 'qe';
          }

          return handler.next(options);
        },
      ),
    )
    // ② 요청/응답 로그 Interceptor (★항상 맨 뒤)
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
      ),
    );

  static Dio get instance => _dio;
}
