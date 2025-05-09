import 'package:flutter/material.dart';

class StressDetailScreen extends StatelessWidget {
  const StressDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StressDetailScreen'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          'StressDetailScreen 화면입니다',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 26, 26, 26)),
        ),
      ),
    );
  }
}
