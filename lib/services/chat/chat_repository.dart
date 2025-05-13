import 'package:minibuddy/services/chat/chat_api.dart';

class ChatRepository {
  final ChatApi api;

  ChatRepository(this.api);

  // 일반 대화 요청 (chatCount < 10)
  Future<String> sendChat(String chat) async {
    try {
      final result = await api.sendChatRequest(chat);
      return result['reply'] ?? 'No response from API';
    } catch (e) {
      rethrow;
    }
  }

  // 기억력 질문 요청 (chatCount >= 10)
  Future<String> sendMemoryQuestion(String chat) async {
    try {
      final result = await api.sendMemoryQuestionRequest(chat);
      return result['reply'] ?? 'No response from API';
    } catch (e) {
      rethrow;
    }
  }

  // 기억력 질문에 대한 답변
  Future<String> sendMemoryAnswer(String chat, String questionId) async {
    try {
      final result = await api.sendMemoryAnswerRequest(chat, questionId);
      return result['reply'] ?? 'No response from API';
    } catch (e) {
      rethrow;
    }
  }
}
