import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:minibuddy/blocs/user/user_bloc.dart';
import 'package:minibuddy/blocs/user/user_event.dart';
import 'package:minibuddy/blocs/user/user_state.dart';
import 'package:minibuddy/data/user/user_repository.dart';
import 'package:minibuddy/models/user_status_model.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'package:minibuddy/screens/user/emotion_distribution_painter.dart';
import 'package:minibuddy/screens/user/emotion_flow_painter.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = UserBloc(repository: UserRepository(context))..add(LoadUserData());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Status', style: TextStyle(fontSize: 20.sp)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0, // 스크롤 시 배경/그림자 안 생기게
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // 또는 light
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // 배경 이미지
            Positioned.fill(
              child: Image.asset(
                'assets/images/home_background.png', // 원하는 배경 이미지 경로
                fit: BoxFit.cover,
              ),
            ),
            // 기존 내용
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  final status = state.status;
                  final flow = state.flow;
                  final distribution = state.distribution;
                  return SafeArea(
                    top: true,
                    bottom: false,
                    child: _buildContent(status, flow, distribution),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    UserStatusModel status,
    List<EmotionFlowModel> flow,
    EmotionDistributionModel distribution,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalChats(status.chatCount),
          SizedBox(height: 16.h),
          _buildScoreCards(status),
          SizedBox(height: 16.h),
          _buildFlowChart(flow),
          SizedBox(height: 16.h),
          _buildDistributionChart(distribution),
        ],
      ),
    );
  }

  Widget _buildTotalChats(int totalChats) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w), // 양옆 여백 최소화
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Here's what $totalChats\nchats say about you.",
          style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Pretendard',
              color: Colors.grey[800]),
        ),
      ),
    );
  }

  Widget _buildScoreCards(UserStatusModel status) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      children: [
        _buildScoreCard('Depression', status.depScore, '/user/depression'),
        _buildScoreCard('Anxiety', status.anxScore, '/user/anxiety'),
        _buildScoreCard('Stress', status.strScore, '/user/stress'),
        _buildScoreCard('Memory', status.mciScore, '/user/memory'),
      ],
    );
  }

  Widget _buildScoreCard(String label, int score, String route) {
    String imagePath;
    if (score <= 12) {
      imagePath = 'assets/images/blue.png';
    } else if (score <= 20) {
      imagePath = 'assets/images/yellow.png';
    } else {
      imagePath = 'assets/images/red.png';
    }

    return InkWell(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(205, 255, 255, 255),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.sp, color: Colors.grey[800]),
              ],
            ),
            const Spacer(),
            Center(
              child: Image.asset(
                imagePath,
                width: 100.w,
                height: 100.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowChart(List<EmotionFlowModel> flow) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(205, 255, 255, 255),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Weekly Mood',
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Check your emotional trends',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey[500],
              ),
            ),
          ),
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: CustomPaint(
              painter: EmotionFlowPainter(flow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionChart(EmotionDistributionModel distribution) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(205, 255, 255, 255),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Monthly Overview',
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Hidden notes in your talks',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.grey[500],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: CustomPaint(
              painter: EmotionDistributionPainter(distribution),
            ),
          ),
        ],
      ),
    );
  }
}
