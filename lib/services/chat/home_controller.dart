import 'package:minibuddy/services/chat/chat_service.dart';
import 'package:minibuddy/services/chat/stt_controller.dart';
import 'package:minibuddy/services/chat/tts_controller.dart';

class HomeController {
  final ChatService chatService;
  final ChatTtsService ttsService;
  final ChatSttService ChatSttService;

  HomeController({
    required this.chatService,
    required this.ttsService,
    required this.ChatSttService,
  });

  Future<void> handleSpeechFlow({
    required Function(String) onRecognized,
    required Function(String) onResponse,
    required Function() onTtsComplete,
    required Function() onError,
  }) async {
    await ChatSttService.startListening();

    final text = ChatSttService.finalText;
    if (text.isNotEmpty) {
      onRecognized(text);
      try {
        final response = await chatService.handleChatRequest(text, 0);
        onResponse(response);
        await ttsService.speak(response, onComplete: onTtsComplete);
      } catch (e) {
        print('❌ 전체 흐름 중 오류: $e');
        onError();
      }
    }
  }
}
