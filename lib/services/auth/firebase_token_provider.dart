import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await user.getIdToken(true); // 강제 새로 발급
  }
  return null;
}
