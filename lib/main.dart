import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/config.dart';
import 'package:minibuddy/utils/router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:js' as js;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📦 백그라운드 메시지 수신: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase Initialized');

  if (!kIsWeb && Platform.isAndroid) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  await _initFCM(); // 플랫폼별 내부에서 분기

  runApp(const MinibuddyApp());
}

Future<void> _initFCM() async {
  final messaging = FirebaseMessaging.instance;

  // 서비스워커 등록 - 웹
  if (kIsWeb) {
    final navigator = js.context['navigator'];
    if (navigator != null && navigator.hasProperty('serviceWorker')) {
      navigator['serviceWorker']
          .callMethod('register', ['firebase-messaging-sw.js']);
      print('✅ ServiceWorker registered');
    } else {
      print('🚫 ServiceWorker not supported in this browser');
    }
  }

  // 권한 요청
  await messaging.requestPermission();

  // 토큰 발급
  String? token;
  if (kIsWeb) {
    token = await messaging.getToken(vapidKey: vapidKey); // from config
  } else if (Platform.isAndroid) {
    token = await messaging.getToken();
  }

  print('🔑 FCM Token: $token');

  // 포그라운드 메시지 리스너
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 포그라운드 메시지 수신: ${message.notification?.title}');
  });
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
            surfaceTint: Colors.transparent,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[400],
            contentTextStyle: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
