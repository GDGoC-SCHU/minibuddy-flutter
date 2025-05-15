import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    _initializeSpeech(); // 마이크 권한은 speech_to_text가 자체 요청함
  }

  /// STT 초기화 (권한 요청도 자동 포함)
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
  void _startListening() async {
    if (!speechAvailable) {
      print("⚠️ 음성 인식 기능이 초기화되지 않음");
      return;
    }

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
  void _stopListening() async {
    await _speech.stop();
    setState(() {
      isListening = false;
    });
  }

  /// 설정 이동 다이얼로그
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
              stt.SpeechToText().stop(); // 권한 없을 때 STT 종료
              stt.SpeechToText().cancel();
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
        title: const Text('음성 인식 테스트'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recognizedText.isEmpty ? '음성 인식 텍스트가 없습니다.' : recognizedText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            FloatingActionButton(
              onPressed: isListening ? _stopListening : _startListening,
              child: Icon(isListening ? Icons.stop : Icons.mic, size: 36),
              backgroundColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
