import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/profile/profile_bloc.dart';
import 'package:minibuddy/blocs/profile/profile_event.dart';
import 'package:minibuddy/blocs/profile/profile_state.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

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

          content = ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                dense: true,
                title: const Text('Account Info'),
                trailing: Text(profile.email,
                    style: TextStyle(color: Colors.grey[700])),
              ),
              ListTile(
                dense: true,
                title: const Text('Change Nickname'),
                trailing: _trailingText(profile.name),
                onTap: () => _navigateAndPatch(context, 'nickname'),
              ),
              ListTile(
                dense: true,
                title: const Text('Change Birthday'),
                trailing: _trailingText(
                  '${profile.birthdate.year}.${profile.birthdate.month.toString().padLeft(2, '0')}.${profile.birthdate.day.toString().padLeft(2, '0')}',
                ),
                onTap: () => _navigateAndPatch(context, 'birthday'),
              ),
              ListTile(
                dense: true,
                title: const Text('Change Keywords'),
                trailing: _trailingText(profile.keywords.join(', ')),
                onTap: () => _navigateAndPatch(context, 'keyword'),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                dense: true,
                title: const Text('Open Source Licenses'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey),
                onTap: () => showLicensePage(context: context),
              ),
              ListTile(
                dense: true,
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey),
                onTap: () {},
              ),
              ListTile(
                dense: true,
                title: const Text('Terms of Use'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Colors.grey),
                onTap: () {},
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {}, // TODO
                child:
                    const Text('Log out', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {}, // TODO
                child: const Text('Delete Account',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('My Page')),
          body: content,
        );
      },
    );
  }

  Widget _trailingText(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: const TextStyle(color: Colors.grey)),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: Colors.grey),
      ],
    );
  }
}
