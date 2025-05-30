import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/main.dart';

// Onboarding
import 'package:minibuddy/screens/onboarding/initial_screen.dart';
import 'package:minibuddy/screens/onboarding/nickname_input_screen.dart';
import 'package:minibuddy/screens/onboarding/birthday_input_screen.dart';
import 'package:minibuddy/screens/onboarding/keyword_input_screen.dart';
import 'package:minibuddy/screens/onboarding/welcome_screen.dart';

// Home
import 'package:minibuddy/screens/home/main/home_screen.dart';

// MyPage
import 'package:minibuddy/screens/home/my_page_screen.dart';

// User
import 'package:minibuddy/screens/user/user_screen.dart';

import 'package:minibuddy/screens/history/anxiety_detail_screen.dart';
import 'package:minibuddy/screens/history/depression_detail_screen.dart';
import 'package:minibuddy/screens/history/stress_detail_screen.dart';
import 'package:minibuddy/screens/history/memory_detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(path: '/', builder: (_, __) => const InitialScreen()),

    // Onboarding
    GoRoute(
      path: '/onboarding/nickname',
      pageBuilder: (_, __) => MaterialPage(
        child: NicknameInputScreen(),
      ),
    ),
    GoRoute(
      path: '/edit/nickname',
      pageBuilder: (_, __) => MaterialPage(
        child: NicknameInputScreen(isFromEdit: true),
      ),
    ),
    GoRoute(
      path: '/onboarding/birthday',
      pageBuilder: (_, __) => MaterialPage(
        child: BirthdayInputScreen(),
      ),
    ),
    GoRoute(
      path: '/edit/birthday',
      pageBuilder: (_, __) => MaterialPage(
        child: BirthdayInputScreen(isFromEdit: true),
      ),
    ),
    GoRoute(
      path: '/onboarding/keyword',
      pageBuilder: (_, __) => MaterialPage(
        child: KeywordInputScreen(),
      ),
    ),
    GoRoute(
      path: '/edit/keyword',
      pageBuilder: (_, __) => MaterialPage(
        child: KeywordInputScreen(isFromEdit: true),
      ),
    ),
    GoRoute(
      path: '/onboarding/welcome',
      pageBuilder: (_, __) => const MaterialPage(
        child: WelcomeScreen(),
      ),
    ),

    // Home
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),

    // User
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserScreen(),
    ),

    GoRoute(
        path: '/user/anxiety', builder: (_, __) => const AnxietyDetailScreen()),
    GoRoute(
        path: '/user/depression',
        builder: (_, __) => const DepressionDetailScreen()),
    GoRoute(
        path: '/user/stress', builder: (_, __) => const StressDetailScreen()),
    GoRoute(
        path: '/user/memory', builder: (_, __) => const MemoryDetailScreen()),

    // MyPage
    GoRoute(
      path: '/mypage',
      builder: (context, state) => const MyPageScreen(), // BlocProvider 제거됨
    ),
  ],
);
