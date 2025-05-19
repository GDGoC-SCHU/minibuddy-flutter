import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/profile/profile_bloc.dart';
import 'package:minibuddy/blocs/profile/profile_event.dart';
import 'package:minibuddy/blocs/profile/profile_state.dart';
import 'package:minibuddy/data/profile/profile_repository.dart';
import 'package:minibuddy/services/auth/acount_service.dart';

import 'package:minibuddy/services/auth/auth_service.dart';

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
        _bloc.add(UpdateProfile(nickname: result));
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                              color: const Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
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
                          title: Text('Nickname',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: _trailingText(profile.nickname),
                          onTap: () => _navigateAndPatch(context, 'nickname'),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Birthday',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: _trailingText(
                            '${profile.birthdate.year}.${profile.birthdate.month.toString().padLeft(2, '0')}.${profile.birthdate.day.toString().padLeft(2, '0')}',
                          ),
                          onTap: () => _navigateAndPatch(context, 'birthday'),
                        ),
                        ListTile(
                          dense: true,
                          title: Text('Interests',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19.w,
                            color: const Color.fromARGB(255, 86, 86, 86),
                          ),
                          onTap: () => _navigateAndPatch(context, 'keyword'),
                        ),
                        SizedBox(height: 32.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                              color: const Color.fromARGB(255, 86, 86, 86),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          dense: true,
                          title: Text('Open Source Licenses',
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard')),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 19.w,
                            color: const Color.fromARGB(255, 86, 86, 86),
                          ),
                          onTap: () => showLicensePage(context: context),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            'App Version',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 19.sp,
                                fontFamily: 'Pretendard'),
                          ),
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 86, 86, 86),
                                fontSize: 19.sp,
                                fontFamily: 'Pretendard'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 5.h),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () => AuthService.logout(context),
                        child: Text(
                          'Log out',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp),
                        ),
                      ),
                      TextButton(
                        onPressed: () => AccountService.deleteUser(context),
                        child: Text(
                          'Delete Account',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp),
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
              title: Text('My Page', style: TextStyle(fontSize: 20.sp)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(child: content),
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
            style: TextStyle(
                color: const Color.fromARGB(255, 86, 86, 86),
                fontFamily: 'Pretendard',
                fontSize: 19.sp)),
        SizedBox(width: 10.w),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 19.w,
          color: const Color.fromARGB(255, 86, 86, 86),
        ),
      ],
    );
  }
}
