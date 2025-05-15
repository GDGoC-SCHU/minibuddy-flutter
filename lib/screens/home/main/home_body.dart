import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final String serverResponse;

  const HomeBody({
    super.key,
    required this.serverResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(0, 245, 245, 245),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 최소 높이만 차지하도록 변경
        mainAxisAlignment: MainAxisAlignment.start, // 위에서부터 위젯 붙이기
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo_b.png',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 50),
          if (serverResponse.isNotEmpty)
            Text(
              serverResponse,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 116, 116, 116),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard'),
            ),
          const SizedBox(height: 30),
          Center(
            child: Image.asset(
              'assets/images/character.png',
              width: 300,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
}
