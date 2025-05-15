import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/profile/profile_bloc.dart';
import 'package:minibuddy/blocs/profile/profile_event.dart';
import 'package:minibuddy/blocs/profile/profile_state.dart';
import 'package:minibuddy/data/profile/profile_repository.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late final ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProfileBloc(repository: ProfileRepository(context))
      ..add(LoadProfile());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _navigateAndPatch(BuildContext context, String field) async {
    final result = await context.push('/edit/$field');

    if (result != null) {
      if (field == 'nickname' && result is String) {
        _bloc.add(UpdateProfile(name: result));
      } else if (field == 'birthday' && result is DateTime) {
        _bloc.add(UpdateProfile(birthdate: result));
      } else if (field == 'keyword' && result is List<String>) {
        _bloc.add(UpdateProfile(keywords: result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          Widget content = const Center(child: CircularProgressIndicator());

          if (state is ProfileLoaded) {
            final profile = state.profile;

            content = Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ListTile(
                        //   dense: true,
                        //   title: const Text('Account Info',
                        //       style: TextStyle(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.w700,
                        //           fontFamily: 'Pretendard')),
                        //   trailing: Text(
                        //     profile.email,
                        //     style: TextStyle(
                        //         color: Colors.grey[700],
                        //         fontFamily: 'Pretendard',
                        //         fontSize: 16),
                        //   ),
                        // ),
                        ListTile(
                          dense: true,
                          title: const Text('Nickname',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: _trailingText(profile.name),
                          onTap: () => _navigateAndPatch(context, 'nickname'),
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('Birthday',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: _trailingText(
                            '${profile.birthdate.year}.${profile.birthdate.month.toString().padLeft(2, '0')}.${profile.birthdate.day.toString().padLeft(2, '0')}',
                          ),
                          onTap: () => _navigateAndPatch(context, 'birthday'),
                        ),
                        ListTile(
                          dense: true,
                          title: const Text('Interests',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: Color.fromARGB(255, 86, 86, 86),
                          ),
                          onTap: () => _navigateAndPatch(context, 'keyword'),
                        ),
                        const SizedBox(height: 32),
                        const SizedBox(height: 32),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                              color: Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          dense: true,
                          title: const Text('Open Source Licenses',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: Color.fromARGB(255, 86, 86, 86),
                          ),
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
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: 'Pretendard'),
                          ),
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(
                                color: Color.fromARGB(255, 86, 86, 86),
                                fontSize: 20,
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
                              color: Colors.red,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
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
              backgroundColor: Colors.transparent, // 배경 비침
              elevation: 0,
            ),
            extendBodyBehindAppBar: true, // AppBar 뒤로 배경 확장
            backgroundColor: Colors.transparent, // 완전 투명 설정
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_background.png', // 배경 이미지 경로
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(child: content), // 기존 UI 유지
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _trailingText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text,
            style: const TextStyle(
                color: Color.fromARGB(255, 86, 86, 86),
                fontFamily: 'Pretendard',
                fontSize: 20)),
        const SizedBox(width: 10),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 20,
          color: Color.fromARGB(255, 86, 86, 86),
        ),
      ],
    );
  }
}
