import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  bool speechAvailable = false;
  String recognizedText = "";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    speechAvailable = await _speech.initialize(
      onError: (val) {
        print('🛑 Speech error: ${val.errorMsg}');
        if (val.errorMsg == 'error_no_match') {
          setState(() {
            isListening = false; // 버튼 상태 복구
          });
          return;
        }
      },
      onStatus: (status) {
        print('🎙️ Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() {
            isListening = false;
          });
        }
      },
    );

    if (!speechAvailable) {
      print("❌ STT 초기화 실패 또는 권한 거부됨");
      _showPermissionDialog();
    } else {
      print("✅ STT 초기화 성공 및 마이크 권한 허용됨");
    }
  }

  Future<void> _startListening() async {
    if (!speechAvailable) return;

    setState(() {
      isListening = true;
      recognizedText = "";
    });

    await _speech.listen(
      pauseFor: const Duration(seconds: 3), // 3초간 말 없으면 자동 종료
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      isListening = false;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Request"),
        content: const Text(
          "Microphone permission was denied. Please allow it in the settings.",
        ),
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
        // 배경 이미지
        Positioned.fill(
          child: Image.asset(
            'assets/images/home_background.png',
            fit: BoxFit.cover,
          ),
        ),

        // 메인 화면 내용
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
              // 캐릭터 이미지 중앙
              Center(
                child: Image.asset(
                  'assets/images/character.png',
                  width: 160,
                  height: 160,
                ),
              ),
              const SizedBox(height: 20),
              // 음성 인식 텍스트
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  recognizedText.isEmpty ? '음성 인식 텍스트가 없습니다.' : recognizedText,
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
                  // 마이페이지
                  ElevatedButton.icon(
                    onPressed: () => context.push('/mypage'),
                    icon: const Icon(Icons.settings),
                    label: const Text('My Page'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  // 마이크 버튼
                  FloatingActionButton(
                    onPressed: isListening ? _stopListening : _startListening,
                    child: Icon(isListening ? Icons.stop : Icons.mic),
                    backgroundColor: const Color.fromARGB(255, 130, 130, 130),
                  ),
                  // 상태 페이지
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
