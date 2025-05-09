import 'package:flutter/material.dart';

class MemoryDetailScreen extends StatelessWidget {
  const MemoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MemoryDetailScreen'),
      ),
      body: Center(
        child: Text(
          'MemoryDetailScreen 화면입니다',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 26, 26, 26)),
        ),
      ),
    );
  }
}
