import 'package:dio/dio.dart';

class ChatApi {
  final Dio dio;

  ChatApi(this.dio);

  static const String firebaseToken = 'YOUR_HARDCODED_FIREBASE_ID_TOKEN';

  // 일반 대화 요청 (chatCount < 10)
  Future<Map<String, dynamic>> sendChatRequest(String chat) async {
    final response = await dio.post(
      '/api/chat',
      data: {
        'chat': chat,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $firebaseToken',
          // 일반 대화 요청은 X-Chat-Request-Type 헤더 생략
        },
      ),
    );
    return response.data;
  }

  // 기억력 질문 요청 (chatCount >= 10)
  Future<Map<String, dynamic>> sendMemoryQuestionRequest(String chat) async {
    final response = await dio.post(
      '/api/chat',
      data: {
        'chat': chat,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $firebaseToken',
          'X-Chat-Request-Type': 'memory-question',
        },
      ),
    );
    return response.data;
  }

  // 기억력 질문에 대한 답변
  Future<Map<String, dynamic>> sendMemoryAnswerRequest(
      String chat, String questionId) async {
    final response = await dio.post(
      '/api/chat/memory-answer',
      data: {
        'chat': chat,
        'question_id': questionId,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $firebaseToken',
        },
      ),
    );
    return response.data;
  }
}
