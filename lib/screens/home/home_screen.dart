import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
        // 🙌 🙌 🙌 여기 false로 변경할 것!!
        automaticallyImplyLeading: true,
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
}
