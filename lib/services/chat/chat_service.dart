import 'package:minibuddy/services/chat/chat_repository.dart';

class ChatService {
  final ChatRepository repository;

  ChatService(this.repository);

  Future<String> handleChatRequest(String chat, int chatCount) async {
    if (chatCount < 10) {
      // chatCount가 10 미만일 경우, 일반 대화 요청
      return await repository.sendChat(chat);
    } else {
      // chatCount가 10 이상일 경우, 기억력 질문 요청
      final response = await repository.sendMemoryQuestion(chat);
      // 질문 ID가 포함된 응답을 받으면 그에 맞는 처리를 이어가도록 설정
      return response;
    }
  }

  Future<String> handleMemoryAnswer(String chat, String questionId) async {
    // 기억력 질문에 대한 답변
    return await repository.sendMemoryAnswer(chat, questionId);
  }
}
