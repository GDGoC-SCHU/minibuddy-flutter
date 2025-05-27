import 'dart:html' as html;

bool isIosWeb() {
  final ua = html.window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') || ua.contains('ipad');
}
