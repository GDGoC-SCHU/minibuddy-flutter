import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

enum AuthStatus {
  loginSuccess,
  registerSuccess,
  loginFailed,
}

class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<(AuthStatus, User?)> loginWithGoogle([String? fcmToken]) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return (AuthStatus.loginFailed, null);

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (user != null) {
        OnboardingState().uid = user.uid;

        if (!isNewUser) {
          final tokenToSend = fcmToken ?? 'mock-fcm-token'; // fallback 사용
          final response =
              await ApiClient.instance.post('/api/user/fcm-update', data: {
            'fcm-token': tokenToSend,
          });
          print('FCM 업데이트 응답: ${response.data}');
        }
      }

      return (
        isNewUser ? AuthStatus.registerSuccess : AuthStatus.loginSuccess,
        user
      );
    } catch (e) {
      print('구글 로그인 오류: $e');
      return (AuthStatus.loginFailed, null);
    }
  }
}
