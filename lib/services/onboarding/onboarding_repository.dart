import 'package:minibuddy/services/onboarding/onboarding_api.dart';
import 'package:minibuddy/services/onboarding/onboarding_state.dart';

class OnboardingRepository {
  final OnboardingApi _api = OnboardingApi();

  Future<void> submitSignup() async {
    final state = OnboardingState();

    final payload = {
      "uid": state.uid,
      "nickname": state.nickname,
      "birthdate": state.birthdate,
      "keywords": state.keywords,
      "fcm_token": state.fcmToken,
    };

    final response = await _api.signup(payload);
    if (response.statusCode != 200) {
      throw Exception('회원가입 실패');
    }
  }
}
