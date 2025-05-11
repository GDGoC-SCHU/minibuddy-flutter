import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/profile/profile_bloc.dart';
import 'package:minibuddy/blocs/profile/profile_event.dart';
import 'package:minibuddy/blocs/profile/profile_state.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  void _navigateAndPatch(BuildContext context, String field) async {
    final bloc = context.read<ProfileBloc>();
    final result = await context.push('/edit/$field');

    if (result != null) {
      if (field == 'nickname' && result is String) {
        bloc.add(UpdateProfile(name: result));
      } else if (field == 'birthday' && result is DateTime) {
        bloc.add(UpdateProfile(birthdate: result));
      } else if (field == 'keyword' && result is List<String>) {
        bloc.add(UpdateProfile(keywords: result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        Widget content = const SizedBox.shrink();

        if (state is ProfileLoaded) {
          final profile = state.profile;

          content = Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Account Info',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard')),
                        trailing: Text(
                          profile.email,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontFamily: 'Pretendard',
                              fontSize: 16),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Change Nickname',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard')),
                        trailing: _trailingText(profile.name),
                        onTap: () => _navigateAndPatch(context, 'nickname'),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Change Birthday',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard')),
                        trailing: _trailingText(
                          '${profile.birthdate.year}.${profile.birthdate.month.toString().padLeft(2, '0')}.${profile.birthdate.day.toString().padLeft(2, '0')}',
                        ),
                        onTap: () => _navigateAndPatch(context, 'birthday'),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Change Keywords',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard')),
                        trailing: _trailingText(profile.keywords.join(', ')),
                        onTap: () => _navigateAndPatch(context, 'keyword'),
                      ),
                      const SizedBox(height: 32),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: const Text('Open Source Licenses',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard')),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Colors.grey),
                        onTap: () => showLicensePage(
                          context: context,
                        ),
                      ),
                      const ListTile(
                        dense: true,
                        title: Text(
                          'App Version',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Pretendard'),
                        ),
                        trailing: Text(
                          '1.0.0',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Pretendard'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.red, fontFamily: 'Pretendard'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                            color: Colors.red, fontFamily: 'Pretendard'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Page',
                style: TextStyle(fontFamily: 'Pretendard')),
          ),
          body: SafeArea(child: content),
        );
      },
    );
  }

  Widget _trailingText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text,
            style: const TextStyle(
                color: Colors.grey, fontFamily: 'Pretendard', fontSize: 16)),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: Colors.grey),
      ],
    );
  }
}
