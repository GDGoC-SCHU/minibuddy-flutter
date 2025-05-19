import 'package:dio/dio.dart';
import 'package:minibuddy/utils/api_client.dart';

class ChatApi {
  final Dio dio;
  ChatApi(this.dio);

  /// 1) 일반 대화(chatCount < 10)
  Future<Map<String, dynamic>> sendChatRequest(
    String message, {
    Map<String, dynamic>? extra,
  }) async {
    final response = await ApiClient.instance.post(
      '/api/chat',
      data: {'chat': message},
      options: Options(extra: extra), // extra 전달
    );
    return response.data;
  }

  // 기억 질문 요청
  Future<Map<String, dynamic>> sendMemoryQuestionRequest(
    String message, {
    Map<String, dynamic>? extra,
  }) async {
    final response = await ApiClient.instance.post(
      '/api/chat/memory',
      data: {'chat': message},
      options: Options(extra: extra), // extra 전달
    );
    return response.data;
  }

  // 3) 기억력 질문에 대한 답변
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
