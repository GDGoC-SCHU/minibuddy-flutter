import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('UserScreen 화면입니다'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/user/depression');
              },
              child: const Text('우울감 상세'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/user/anxiety');
              },
              child: const Text('불안감 상세'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/user/stress');
              },
              child: const Text('스트레스 상세'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/user/memory');
              },
              child: const Text('기억력 상세'),
            ),
          ],
        ),
      ),
    );
  }
}
