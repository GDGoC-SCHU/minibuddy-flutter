import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/chat/chat_api.dart';
import 'package:minibuddy/services/chat/chat_repository.dart';
import 'package:minibuddy/services/chat/chat_service.dart';
import 'package:minibuddy/services/chat/chat_tts.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
        print('🧨 Speech error: ${val.errorMsg}');
        if (val.errorMsg == 'error_no_match') {
          setState(() => isListening = false);
          return;
        }
      },
      onStatus: (status) async {
        print('🎙️ Speech status: $status');
        if (status == 'done' && !hasSentToServer) {
          hasSentToServer = true;
          if (finalText.isNotEmpty) {
            print('📤 Sending to server: "$finalText"');
            final response = await chatService.handleChatRequest(finalText, 0);
            print('📥 Server response: $response');
            setState(() {
              serverResponse = response;
            });
            await ttsService.speak(response);
          } else {
            print('⚠️ No text recognized to send');
          }
        }
      },
    );

    if (!speechAvailable) {
      print("❌ STT initialization failed or permission denied");
      _showPermissionDialog();
    } else {
      print("✅ STT initialized");
    }
  }

  Future<void> _startListening() async {
    if (!speechAvailable) return;

    setState(() {
      isListening = true;
      hasSentToServer = false;
      recognizedText = "";
      finalText = "";
      serverResponse = "";
    });

    await _speech.listen(
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        final text = result.recognizedWords;
        print('🨠 Recognized: $text');

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
          body: Column(
            children: [
              const Spacer(),
              if (serverResponse.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    serverResponse,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/character.png',
                  width: 160,
                  height: 160,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  recognizedText.isEmpty ? ' ' : recognizedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const Spacer(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.push('/mypage'),
                    icon: const Icon(Icons.settings),
                    label: const Text('My Page'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: isListening ? _stopListening : _startListening,
                    child: Icon(isListening ? Icons.stop : Icons.mic),
                    backgroundColor: const Color.fromARGB(255, 130, 130, 130),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/user'),
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('Status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
