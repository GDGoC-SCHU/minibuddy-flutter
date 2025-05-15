import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minibuddy/config.dart';

class ChatTtsService {
  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  Future<void> speak(String text, {Function()? onComplete}) async {
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

      await _player.setFilePath(filePath); // just_audio 방식
      _player.play();

      // 완료 감지
      _player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          print("🔚 TTS 재생 완료");
          onComplete?.call();
        }
      });
    } catch (e) {
      print("❌ TTS 오류 발생: $e");
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
