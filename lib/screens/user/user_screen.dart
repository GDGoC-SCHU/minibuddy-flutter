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
          title: Text('Emotional Status', style: TextStyle(fontSize: 20.sp)),
          elevation: 0,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final status = state.status;
              final flow = state.flow;
              final distribution = state.distribution;
              return _buildContent(status, flow, distribution);
            }
            return const SizedBox.shrink();
          },
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
      padding: EdgeInsets.all(16.w),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Text(
            "In total, you've had $totalChats conversations",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: constraints.maxWidth > 600 ? 30.sp : 25.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
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
    return InkWell(
      onTap: () => context.push(route),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        color: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowChart(List<EmotionFlowModel> flow) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Emotion Flow',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 220.h,
              width: double.infinity,
              child: CustomPaint(
                painter: EmotionFlowPainter(flow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart(EmotionDistributionModel distribution) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Emotion Distribution',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 220.h,
              width: double.infinity,
              child: CustomPaint(
                painter: EmotionDistributionPainter(distribution),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
