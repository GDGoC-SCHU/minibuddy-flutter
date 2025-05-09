import 'package:flutter/material.dart';

class AnxietyDetailScreen extends StatelessWidget {
  const AnxietyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnxietyDetailScreen'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          'AnxietyDetailScreen 화면입니다',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 26, 26, 26)),
        ),
      ),
    );
  }
}
