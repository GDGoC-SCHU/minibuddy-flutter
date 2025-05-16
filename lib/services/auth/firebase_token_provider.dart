import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return await user.getIdToken(); // true면 강제 갱신도 가능
  }
  return null;
}
