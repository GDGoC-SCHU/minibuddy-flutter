import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minibuddy/config.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';
import 'package:minibuddy/utils/router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:minibuddy/web/register_service_worker.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📦 백그라운드 메시지 수신: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformDispatcherError] $error');
    return true;
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase Initialized');

  if (kIsWeb) {
    registerServiceWorker(); // 웹에서만 실행
  }

  if (!kIsWeb) {
    await _initFCM(); // 모바일(Android/iOS)은 자동 요청
  }

  runApp(const MinibuddyApp());
}

Future<void> _initFCM() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  String? token;
  if (kIsWeb) {
    token = await messaging.getToken(vapidKey: vapidKey); // from config.dart
  } else if (Platform.isAndroid) {
    token = await messaging.getToken();
  }

  if (token != null) {
    print('🔑 FCM Token: $token');
    OnboardingState().fcmToken = token!;
  } else {
    print('⚠️ FCM Token을 가져오지 못했습니다.');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? 'Warnning!';
    final body = message.notification?.body ?? '';
    final imageUrl = message.notification?.android?.imageUrl ??
        message.data['image'] ??
        null;

    print('📩 인앱 메시지 수신: $title - $body');

    // 안전하게 프레임 이후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay != null) {
        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(body, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);
        Future.delayed(const Duration(seconds: 4), () => overlayEntry.remove());
      } else {
        print('❌ overlay is null');
      }
    });
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
                fontWeight: FontWeight.w600),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
