import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final String recognizedText;
  final String serverResponse;

  const HomeBody({
    super.key,
    required this.recognizedText,
    required this.serverResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        if (serverResponse.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              serverResponse,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        const SizedBox(height: 16),
        Center(
          child: Image.asset(
            'assets/images/character.png',
            width: 160,
            height: 160,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            recognizedText.isEmpty ? ' ' : recognizedText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
