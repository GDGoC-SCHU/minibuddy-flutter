import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPageScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MyPageScreen 화면입니다'),
            ElevatedButton(
              onPressed: () {
                context.push('/edit/nickname');
              },
              child: const Text('닉네임 다시 입력'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/edit/birthday');
              },
              child: const Text('생일 다시 입력'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/edit/keyword');
              },
              child: const Text('키워드 다시 선택'),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/error/server'),
              child: const Text('서버 오류 테스트'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/error/network'),
              child: const Text('네트워크 오류 테스트'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/loading'),
              child: const Text('로딩 화면 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
