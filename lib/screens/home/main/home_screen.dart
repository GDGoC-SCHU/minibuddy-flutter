import 'package:flutter/material.dart';
import 'package:minibuddy/services/chat/chat_api.dart';
import 'package:minibuddy/services/chat/chat_repository.dart';
import 'package:minibuddy/services/chat/chat_service.dart';
import 'package:minibuddy/services/chat/tts_controller.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'home_body.dart';
import 'home_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ChatService chatService = ChatService(
    ChatRepository(ChatApi(ApiClient.instance)),
  );
  final ChatTtsService ttsService = ChatTtsService();

  bool isListening = false;
  bool speechAvailable = false;
  bool isTtsPlaying = false;
  String recognizedText = "";
  String finalText = "";
  String serverResponse = "";
  bool hasSentToServer = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    speechAvailable = await _speech.initialize(
      onError: (val) {
        print('\uD83E\uDEA8 Speech error: \${val.errorMsg}');
        if (val.errorMsg == 'error_no_match') {
          setState(() => isListening = false);
          return;
        }
      },
      onStatus: (status) async {
        print('\uD83C\uDF99\uFE0F Speech status: \$status');
        if (status == 'done' && !hasSentToServer) {
          hasSentToServer = true;
          if (finalText.isNotEmpty) {
            print('\uD83D\uDCE4 Sending to server: "\$finalText"');
            final response = await chatService.handleChatRequest(finalText, 0);
            print('\uD83D\uDCE5 Server response: \$response');

            setState(() {
              serverResponse = response;
              isTtsPlaying = true;
            });

            try {
              await ttsService.speak(response, onComplete: () {
                if (mounted) {
                  setState(() {
                    isTtsPlaying = false;
                    isListening = false;
                  });
                }
              });
            } catch (e) {
              print('\u274C TTS \uC624\uB958 \uBC1C\uC0DD: \$e');
              if (mounted) {
                setState(() {
                  isTtsPlaying = false;
                  isListening = false;
                });
              } else {
                print('\u26A0\uFE0F No text recognized to send');
                setState(() => isListening = false);
              }
            } finally {
              if (mounted) {
                setState(() {
                  isTtsPlaying = false;
                  isListening = false;
                });
              }
            }
          }
        }
      },
    );

    if (!speechAvailable) {
      print("\u274C STT initialization failed or permission denied");
      _showPermissionDialog();
    } else {
      print("\u2705 STT initialized");
    }
  }

  Future<void> _startListening() async {
    if (!speechAvailable || isTtsPlaying) return;

    setState(() {
      isListening = true;
      hasSentToServer = false;
      recognizedText = "";
      finalText = "";
      serverResponse = "";
    });

    await _speech.listen(
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        final text = result.recognizedWords;
        print('\uD83E\uA8A0 Recognized: \$text');

        if (text.trim().isNotEmpty) {
          finalText = text;
          setState(() => recognizedText = text);
        }
      },
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => isListening = false);
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Request"),
        content: const Text(
            "Microphone permission was denied. Please allow it in the settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _speech.cancel();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/home_background.png',
              fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('HomeScreen'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: HomeBody(
            recognizedText: recognizedText,
            serverResponse: serverResponse,
          ),
          bottomNavigationBar: HomeBottomBar(
            isListening: isListening,
            isTtsPlaying: isTtsPlaying,
            onMicPressed: _startListening,
          ),
        ),
      ],
    );
  }
}
