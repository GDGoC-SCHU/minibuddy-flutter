// lib/web/register_service_worker_web.dart
import 'dart:js' as js;

void registerServiceWorker() {
  final navigator = js.context['navigator'];
  if (navigator != null && navigator.hasProperty('serviceWorker')) {
    navigator['serviceWorker']
        .callMethod('register', ['firebase-messaging-sw.js']);
    print('ServiceWorker registered');
  } else {
    print('ServiceWorker not supported in this browser');
  }
}
