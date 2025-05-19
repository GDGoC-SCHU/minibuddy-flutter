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
          // 1) 회원가입 요청은 토큰 없이 통과
          if (options.path.contains('/api/auth/signup')) {
            return handler.next(options);
          }

          // 2) Firebase 유저 확보 (Web에서는 로그인 직후 null 가능성 보완)
          User? user = FirebaseAuth.instance.currentUser;

          // currentUser가 null일 경우 authStateChanges로 유저 확보 시도
          if (user == null) {
            user = await FirebaseAuth.instance.authStateChanges().firstWhere(
                  (u) => u != null,
                  orElse: () => null,
                );
          }

          // 3) 토큰 강제 갱신
          final token = await user?.getIdToken(true);

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('[APIClient] Authorization 헤더 추가됨');
          } else {
            print('[APIClient] 사용자 인증 없음 → 헤더 미포함');
          }

          // 4) 상황별 커스텀 헤더
          final chatType = options.extra['chatType'];
          if (chatType == 'normal') {
            options.headers['x-chat-type'] = 'normal';
          } else if (chatType == 'memory-question') {
            options.headers['x-chat-type'] = 'memory-question';
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
