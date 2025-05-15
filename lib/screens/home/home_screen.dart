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
    _initializeSpeech(); // STT 초기화 + 마이크 권한 요청
  }

  /// STT 초기화
  void _initializeSpeech() async {
    speechAvailable = await _speech.initialize(
      onError: (val) => print('🛑 Speech error: $val'),
      onStatus: (status) => print('🎙️ Speech status: $status'),
    );

    if (speechAvailable) {
      print("✅ STT 초기화 성공 및 마이크 권한 허용됨");
    } else {
      print("❌ STT 초기화 실패 또는 권한 거부됨");
      _showPermissionDialog();
    }
  }

  /// 음성 인식 시작
  Future<void> _startListening() async {
    if (!speechAvailable) return;

    setState(() {
      isListening = true;
      recognizedText = "";
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
    );
  }

  /// 음성 인식 중단
  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      isListening = false;
    });
  }

  /// 마이크 권한 안내
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("권한 요청"),
        content: const Text("마이크 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _speech.cancel();
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          recognizedText.isEmpty ? '음성 인식 텍스트가 없습니다.' : recognizedText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 마이페이지 이동
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
              // 상태 페이지 이동
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
    );
  }
}
