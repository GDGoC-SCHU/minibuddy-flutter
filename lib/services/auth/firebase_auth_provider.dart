import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

enum AuthStatus {
  loginSuccess,
  registerSuccess,
  loginFailed,
}

class FirebaseAuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<(AuthStatus, User?)> loginWithGoogle() async {
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

      // 로그인 성공 시 uid 저장
      if (user != null) {
        OnboardingState().uid = user.uid;
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
