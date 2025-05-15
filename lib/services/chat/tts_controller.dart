import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minibuddy/config.dart';

class ChatTtsService {
  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  Future<void> speak(String text, {Function? onComplete}) async {
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

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/tts.mp3';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print("🎧 오디오 파일 저장 완료: $filePath");

      // 플레이어가 끝났을 때 콜백
      _player.onPlayerCompletion.listen((event) {
        print("🔚 TTS 재생 완료");
        onComplete?.call();
        _player.dispose(); // 리소스 정리
      });

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
