import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minibuddy/config.dart';

class ChatTtsService {
  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  Future<void> speak(String text) async {
    try {
      print("📣 TTS 요청 시작: $text");

      final response = await _dio.post(
        'https://texttospeech.googleapis.com/v1/text:synthesize',
        queryParameters: {'key': Config.googleApiKey},
        data: {
          'input': {'text': text},
          'voice': {
            'languageCode': 'en-US',
            'name': 'en-US-Neural2-C',
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
          }
        },
      );

      final audioContent = response.data['audioContent'];
      if (audioContent == null) {
        print("❌ TTS 응답에 audioContent 없음");
        return;
      }

      final bytes = base64Decode(audioContent);

      // 임시 파일 생성
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/tts.mp3';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print("🎧 오디오 파일 저장 완료: $filePath");

      // 재생
      final result = await _player.play(filePath, isLocal: true);
      if (result == 1) {
        print("✅ TTS 재생 성공");
      } else {
        print("❌ TTS 재생 실패: $result");
      }
    } catch (e) {
      print("❌ TTS 오류 발생: $e");
    }
  }
}
