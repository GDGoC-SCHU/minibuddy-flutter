import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/utils/router.dart';

void main() {
  runApp(const MinibuddyApp());
}

class MinibuddyApp extends StatelessWidget {
  const MinibuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Minibuddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.grey[800],
          splashColor: Colors.grey.withOpacity(0.2), // 터치 잔상 색
          highlightColor: Colors.grey.withOpacity(0.1), // 누르고 있을 때 배경
          hoverColor: Colors.grey.withOpacity(0.05), // (웹 등) 호버 시 색
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[900],
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretendard',
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[800],
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge:
                TextStyle(color: Colors.black87, fontFamily: 'Pretendard'),
            bodyMedium:
                TextStyle(color: Colors.black54, fontFamily: 'Pretendard'),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.grey[400],
            primary: Colors.grey[800], // 포커스 및 인터랙션 색
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
