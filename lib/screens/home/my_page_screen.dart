import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/profile/profile_bloc.dart';
import 'package:minibuddy/blocs/profile/profile_event.dart';
import 'package:minibuddy/blocs/profile/profile_state.dart';
import 'package:minibuddy/data/profile/profile_repository.dart';
import 'package:minibuddy/models/profile_model.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  void _navigateAndPatch(BuildContext context, String field) async {
    final bloc = context.read<ProfileBloc>();

    final result = await context.push('/edit/$field');

    if (result != null) {
      if (field == 'nickname' && result is String) {
        debugPrint('🔁 PATCH name: $result');
        bloc.add(UpdateProfile(name: result));
      } else if (field == 'birthday' && result is DateTime) {
        debugPrint('🔁 PATCH birthdate: $result');
        bloc.add(UpdateProfile(birthdate: result));
      } else if (field == 'keyword' && result is List) {
        final keywords = List<String>.from(result.map((e) => e.toString()));
        debugPrint('🔁 PATCH keywords: $keywords');
        bloc.add(UpdateProfile(keywords: keywords));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileBloc(repository: ProfileRepository())..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(title: const Text('마이페이지')),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final Profile profile = state.profile;

              debugPrint('📥 GET profile: ${profile.toJson()}');

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  ListTile(
                    title: const Text('계정 정보'),
                    subtitle: Text(profile.email),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('닉네임 변경'),
                    trailing: Text(profile.name),
                    onTap: () => _navigateAndPatch(context, 'nickname'),
                  ),
                  ListTile(
                    title: const Text('생년월일 변경'),
                    trailing: Text(
                      '${profile.birthdate.year}년 ${profile.birthdate.month}월 ${profile.birthdate.day}일',
                    ),
                    onTap: () => _navigateAndPatch(context, 'birthday'),
                  ),
                  ListTile(
                    title: const Text('키워드 변경'),
                    trailing: Text(profile.keywords.join(', ')),
                    onTap: () => _navigateAndPatch(context, 'keyword'),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
