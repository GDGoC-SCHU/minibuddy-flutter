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
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.transparent,
      elevation: 8,
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // 좌우 마진 줄임
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(70),
                onTap: () => context.push('/mypage'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MYPAGE',
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Calsans',
                      //fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 120, 95, 60),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(70),
                onTap: () => context.push('/user'),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'STATUS',
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Calsans',
                      //fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 120, 95, 60),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Dynapuff, Poetsenone, Calsans, HakgyoansimDunggeunmiso, Pretendard
