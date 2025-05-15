import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBottomBar extends StatelessWidget {
  final bool isListening;
  final bool isTtsPlaying;
  final VoidCallback onMicPressed;

  const HomeBottomBar({
    super.key,
    required this.isListening,
    required this.isTtsPlaying,
    required this.onMicPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.push('/mypage'),
              icon: const Icon(Icons.settings),
              label: const Text('My Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
            ),
            FloatingActionButton(
              onPressed: isListening || isTtsPlaying ? null : onMicPressed,
              child: Icon(isListening ? Icons.stop : Icons.mic),
              backgroundColor: const Color.fromARGB(255, 130, 130, 130),
            ),
            ElevatedButton.icon(
              onPressed: () => context.push('/user'),
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
    );
  }
}
