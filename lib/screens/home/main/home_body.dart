import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo_b.png',
            width: 180.w,
            height: 180.w,
          ),
          SizedBox(height: 20.h),
          if (serverResponse.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            ),
          SizedBox(height: 30.h),
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
