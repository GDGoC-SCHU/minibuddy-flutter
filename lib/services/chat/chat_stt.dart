import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:minibuddy/config.dart'; // Config에서 apiKey를 가져옵니다.

class SpeechToTextAPI {
  final Dio dio;
  final String apiKey;

  SpeechToTextAPI({required this.dio})
      : apiKey = Config.googleApiKey; // config.dart에서 API Key 사용

  // 음성을 텍스트로 변환하는 함수
  Future<String> transcribeAudio(File audioFile) async {
    try {
      final uri = Uri.https('speech.googleapis.com', '/v1/speech:recognize');

      // 음성 파일을 읽어서 Base64로 인코딩
      final audioBytes = await audioFile.readAsBytes();
      final audioBase64 = base64Encode(audioBytes);

      // Google Cloud STT API 요청 본문
      final Map<String, dynamic> requestBody = {
        'config': {
          'encoding': 'LINEAR16', // WAV 파일
          'sampleRateHertz': 16000,
          'languageCode': 'en-US', // 언어 설정
        },
        'audio': {
          'content': audioBase64,
        }
      };

      final response = await dio.post(
        uri.toString(),
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      // 응답 데이터에서 텍스트 추출
      if (response.statusCode == 200) {
        final transcript =
            response.data['results'][0]['alternatives'][0]['transcript'];
        return transcript ?? 'No speech detected';
      } else {
        throw Exception('Failed to transcribe audio');
      }
    } catch (e) {
      print('Error transcribing audio: $e');
      throw Exception('Error transcribing audio');
    }
  }
}
