import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:minibuddy/config.dart';
import 'package:minibuddy/main.dart' show globalNavigatorKey, navigatorKey;
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

Future<void> initFCM() async {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay != null) {
        final overlayEntry = OverlayEntry(
          builder: (context) => _buildFCMToast(title, body, imageUrl),
        );

        overlay.insert(overlayEntry);
        Future.delayed(const Duration(seconds: 4), () => overlayEntry.remove());
      } else {
        print('❌ overlay is null');
      }
    });
  });
}

Widget _buildFCMToast(String title, String body, String? imageUrl) {
  return Positioned(
    top: 32,
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
  );
}
