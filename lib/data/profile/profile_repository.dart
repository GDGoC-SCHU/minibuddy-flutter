import 'package:flutter/material.dart';
import 'package:minibuddy/models/profile_model.dart';
import 'package:minibuddy/utils/handle_request.dart';
import 'profile_api.dart';

class ProfileRepository {
  final BuildContext context;

  ProfileRepository(this.context);

  Future<Profile> getProfile() async {
    Profile? result;

    await handleRequest<Profile>(
      context: context,
      fetch: fetchProfile,
      onSuccess: (data) {
        result = data;
        debugPrint('GET profile: ${data.toJson()}');
      },
      retry: () => getProfile(),
    );

    return result!; // null이 올 수 없게 보장된 흐름
  }

  Future<void> updateProfile({
    String? name,
    DateTime? birthdate,
    List<String>? keywords,
  }) async {
    await handleRequest<void>(
      context: context,
      fetch: () => patchProfile(
        name: name,
        birthdate: birthdate,
        keywords: keywords,
      ),
      onSuccess: (_) => debugPrint('PATCH 성공'),
      retry: () => updateProfile(
        name: name,
        birthdate: birthdate,
        keywords: keywords,
      ),
    );
  }
}
