import 'package:flutter/material.dart';

class DepressionDetailScreen extends StatelessWidget {
  const DepressionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepressionDetailScreen'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          'DepressionDetailScreen 화면입니다',
          style: TextStyle(
              fontSize: 18, color: const Color.fromARGB(255, 26, 26, 26)),
        ),
      ),
    );
  }
}
