import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/services/chat/chat_api.dart';
import 'package:minibuddy/services/chat/chat_repository.dart';
import 'package:minibuddy/services/chat/chat_service.dart';
import 'package:minibuddy/utils/handle_request.dart';
import 'package:minibuddy/utils/api_client.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('HomeScreen 화면입니다'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 마이페이지 버튼 (좌측)
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/mypage');
                },
                icon: const Icon(Icons.settings),
                label: const Text('My Page'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                ),
              ),
              // 마이크 버튼 (가운데)
              FloatingActionButton(
                onPressed: () {
                  // STT (Speech-to-Text) 음성 인식 부분
                  handleRequest<String>(
                    context: context,
                    fetch: () async {
                      // 여기서 STT로 음성 인식 결과를 받음
                      final text = await getSpeechText(); // 음성 텍스트 변환
                      return text; // 변환된 텍스트 리턴
                    },
                    onSuccess: (data) {
                      // 데이터에 따른 API 요청
                      final chatCount = 5; // 예시 chatCount, 실제로는 상태에서 가져와야 함
                      final chatService = ChatService(
                          ChatRepository(ChatApi(ApiClient.instance)));

                      chatService
                          .handleChatRequest(data, chatCount)
                          .then((response) {
                        print("Server response: $response");
                      });
                    },
                    retry: () {
                      // 실패 시 재시도 로직
                      print("Retrying...");
                    },
                  );
                },
                child: const Icon(Icons.mic),
                backgroundColor:
                    const Color.fromARGB(255, 130, 130, 130), // 마이크 버튼 배경 색
              ),
              // 유저 상태 버튼 (우측)
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/user');
                },
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

  // STT 기능을 처리할 함수
  Future<String> getSpeechText() async {
    // 여기서 Google STT 로직을 처리하고 음성 데이터를 텍스트로 변환
    return "Sample chat text"; // 예시 텍스트
  }
}
