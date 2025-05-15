import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatSttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool hasSentToServer = false;

  bool get isAvailable => _speech.isAvailable;
  bool get isListening => _speech.isListening;

  Future<bool> initialize(Function(String text) onStatusDone,
      Function(String text) onResult) async {
    return await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' && !hasSentToServer) {
          hasSentToServer = true;
          onStatusDone(_recognizedText);
        }
      },
      onError: (error) {
        print('🧨 STT Error: ${error.errorMsg}');
      },
    );
  }

  String _recognizedText = "";

  Future<void> startListening() async {
    hasSentToServer = false;
    _recognizedText = "";
    await _speech.listen(
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        _recognizedText = result.recognizedWords;
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  String get finalText => _recognizedText;
}
