import 'package:dio/dio.dart';

class ChatApi {
  final Dio dio;
  ChatApi(this.dio);

  /// 1) 일반 대화(chatCount < 10)
  Future<Map<String, dynamic>> sendChatRequest(String chat) async {
    final res = await dio.post(
      '/api/chat',
      data: {'chat': chat},
      // 헤더 X | extra X  → Interceptor가 토큰만 붙여 줌
    );
    return res.data;
  }

  /// 2) 기억력 질문(chatCount ≥ 10)
  Future<Map<String, dynamic>> sendMemoryQuestionRequest(String chat) async {
    final res = await dio.post(
      '/api/chat',
      data: {'chat': chat},
      options: Options(
        extra: {'memoryQuestion': true}, // ← 표식만 넘김
      ),
      // 헤더 X (Interceptor가 토큰 + X-Chat-Request-Type 둘 다 붙임)
    );
    return res.data;
  }

  /// 3) 기억력 질문에 대한 답변
  Future<Map<String, dynamic>> sendMemoryAnswerRequest(
      String chat, String questionId) async {
    final res = await dio.post(
      '/api/chat/memory-answer',
      data: {
        'chat': chat,
        'question_id': questionId,
      },
      // 별도 헤더 필요 없음
    );
    return res.data;
  }
}
