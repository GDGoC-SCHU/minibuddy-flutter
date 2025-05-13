import 'package:dio/dio.dart';
import 'package:minibuddy/utils/api_client.dart';

class ChatApi {
  final Dio dio;

  ChatApi(this.dio);

  // 일반 대화 요청 (chatCount < 10)
  Future<Map<String, dynamic>> sendChatRequest(String chat) async {
    final response = await dio.post(
      '/api/chat',
      data: {
        'chat': chat,
      },
      options: Options(
        headers: {
          'X-Chat-Request-Type': 'qe',
          'Authorization': 'Bearer YOUR_FIREBASE_ID_TOKEN',
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
          'X-Chat-Request-Type': 'memory-question',
          'Authorization': 'Bearer YOUR_FIREBASE_ID_TOKEN',
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
          'Authorization': 'Bearer YOUR_FIREBASE_ID_TOKEN',
        },
      ),
    );
    return response.data;
  }
}
