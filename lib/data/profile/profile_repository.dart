import 'package:minibuddy/models/profile_model.dart';
import 'profile_api.dart';

class ProfileRepository {
  Future<Profile> getProfile() => fetchProfile();

  Future<void> updateProfile(
          {String? name, DateTime? birthdate, List<String>? keywords}) =>
      patchProfile(name: name, birthdate: birthdate, keywords: keywords);
}
