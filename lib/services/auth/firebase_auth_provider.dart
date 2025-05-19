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
      User? user = userCredential.user;

      // Firebase Web에서 로그인 복구가 지연될 수 있으므로 명시적으로 기다림
      if (user == null || user.uid.isEmpty) {
        print('UID 복구 대기 중...');
        user = await _auth.authStateChanges().firstWhere((u) => u != null);
        print('UID 복구 완료: ${user!.uid}');
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      OnboardingState().uid = user!.uid;

      if (user != null) {
        OnboardingState().uid = user.uid;

        if (!isNewUser) {
          final tokenToSend = (fcmToken ?? OnboardingState().fcmToken).trim();

          final response = await ApiClient.instance.post(
            '/api/user/fcm-update',
            data: {
              'fcm_token': tokenToSend.isNotEmpty ? tokenToSend : 'unavailable',
            },
          );
          print('FCM 업데이트 응답: ${response.data}');
        }

        return (
          isNewUser ? AuthStatus.registerSuccess : AuthStatus.loginSuccess,
          user
        );
      } else {
        print('user가 null입니다. 로그인 실패로 처리합니다.');
        return (AuthStatus.loginFailed, null);
      }
    } catch (e) {
      print('구글 로그인 오류: $e');
      return (AuthStatus.loginFailed, null);
    }
  }
}
