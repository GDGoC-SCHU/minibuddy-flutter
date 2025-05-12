import 'package:dio/dio.dart';
import 'package:minibuddy/models/profile_model.dart';
import 'package:minibuddy/utils/api_client.dart';

final Dio dio = ApiClient.instance;

Future<Profile> fetchProfile() async {
  try {
    final res = await dio.get('/api/user/profile');
    return Profile.fromJson(res.data);
  } on DioException catch (e) {
    rethrow;
  }
}

Future<void> patchProfile({
  String? name,
  DateTime? birthdate,
  List<String>? keywords,
}) async {
  try {
    final data = {
      if (name != null) 'name': name,
      if (birthdate != null) 'birthdate': birthdate.toIso8601String(),
      if (keywords != null) 'keywords': keywords,
    };
    await dio.patch('/api/user/profile', data: data);
  } on DioException catch (e) {
    rethrow;
  }
}
