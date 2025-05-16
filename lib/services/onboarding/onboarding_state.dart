class OnboardingState {
  String uid = '';
  String nickname = '';
  String birthdate = '';
  List<String> keywords = [];

  static final OnboardingState _instance = OnboardingState._internal();
  factory OnboardingState() => _instance;
  OnboardingState._internal();
}
