import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBody extends StatelessWidget {
  final String serverResponse;
  final String recognizedText;

  const HomeBody({
    super.key,
    required this.serverResponse,
    required this.recognizedText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(0, 245, 245, 245),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Image.asset(
            'assets/images/logo_b.png',
            height: 20.w,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 140.h,
            width: double.infinity,
            child: Container(
              //color: const Color.fromARGB(255, 115, 111, 111),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  serverResponse.isNotEmpty
                      ? ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 280.w),
                          child: Text(
                            serverResponse,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: const Color.fromARGB(255, 116, 116, 116),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        )
                      : recognizedText.isEmpty // STT 중이면 안 보이게
                          ? Image.asset(
                              'assets/images/hello.png',
                              height: 130.w,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink() // 아무것도 안 보이게
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Center(
            child: Image.asset(
              'assets/images/character.png',
              width: 280.w,
              height: 280.w,
            ),
          ),
        ],
      ),
    );
  }
}
