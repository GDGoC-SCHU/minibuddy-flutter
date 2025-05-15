import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/screens/home/main/waveform_widget.dart';
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
      onError: (val) async {
        print('🧨 Speech error: ${val.errorMsg}');

        if (val.errorMsg == 'error_no_match') {
          // 🔁 STT 강제 중단 + UI 복구
          await _speech.stop();
        }

        if (mounted) {
          setState(() {
            isListening = false;
            isTtsPlaying = false;
          });
        }
      },
      onStatus: (status) {
        print('🎙️ Speech status: $status');

        // STT 종료된 경우 마이크 버튼 복구
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() => isListening = false);
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
      listenFor: const Duration(seconds: 10),
      partialResults: true,
      onResult: (result) async {
        final text = result.recognizedWords;
        print('📝 onResult: $text');

        if (text.trim().isNotEmpty) {
          setState(() => recognizedText = text);
          finalText = text;

          if (result.finalResult && !hasSentToServer) {
            hasSentToServer = true;

            print('📤 서버 전송: "$finalText"');
            final response = await chatService.handleChatRequest(finalText, 0);

            setState(() {
              serverResponse = response;
              isTtsPlaying = true;
            });

            try {
              await ttsService.speak(response, onComplete: () async {
                if (mounted) {
                  setState(() {
                    isTtsPlaying = false;
                    isListening = false;
                  });
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (mounted) {
                    setState(() {
                      recognizedText = "";
                      serverResponse = "";
                    });
                  }
                }
              });
            } catch (e) {
              print('❌ TTS 오류 발생: $e');
              if (mounted) {
                setState(() {
                  isTtsPlaying = false;
                  isListening = false;
                });
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) {
                  setState(() {
                    recognizedText = "";
                    serverResponse = "";
                  });
                }
              }
            }
          }
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
          body: SizedBox(
            child: HomeBody(
              serverResponse: serverResponse,
              recognizedText: recognizedText,
            ),
          ),
          floatingActionButton: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (recognizedText.isNotEmpty)
                Positioned(
                  bottom: 90.h,
                  child: Column(
                    children: [
                      Text(
                        recognizedText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: 120.w,
                        height: 40.h,
                        child: const WaveformWidget(),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: Offset(0, -35.h),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 208, 106),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 6.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      onPressed:
                          isListening || isTtsPlaying ? null : _startListening,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: const CircleBorder(),
                      child: Icon(
                        isListening ? Icons.stop : Icons.mic,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: SizedBox(
            height: 0.15.sh,
            child: HomeBottomBar(
              isListening: isListening,
              isTtsPlaying: isTtsPlaying,
              onMicPressed: _startListening,
            ),
          ),
        ),
      ],
    );
  }
}
