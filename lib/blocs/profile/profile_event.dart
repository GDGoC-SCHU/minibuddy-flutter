abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final DateTime? birthdate;
  final List<String>? keywords;

  UpdateProfile({this.name, this.birthdate, this.keywords});
}
