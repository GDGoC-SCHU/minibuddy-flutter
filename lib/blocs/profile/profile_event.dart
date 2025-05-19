abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? nickname;
  final DateTime? birthdate;
  final List<String>? keywords;

  UpdateProfile({this.nickname, this.birthdate, this.keywords});
}
