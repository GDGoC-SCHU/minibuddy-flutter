import 'package:dio/dio.dart';
import 'package:minibuddy/config.dart';
import 'package:minibuddy/models/profile_model.dart';

final dio = Dio(BaseOptions(baseUrl: baseUrl));

Future<Profile> fetchProfile() async {
  final res = await dio.get('/api/user/profile');
  return Profile.fromJson(res.data);
}

Future<void> patchProfile(
    {String? name, DateTime? birthdate, List<String>? keywords}) async {
  final data = {
    if (name != null) 'name': name,
    if (birthdate != null) 'birthdate': birthdate.toIso8601String(),
    if (keywords != null) 'keywords': keywords,
  };
  await dio.patch('/api/user/profile', data: data);
}
