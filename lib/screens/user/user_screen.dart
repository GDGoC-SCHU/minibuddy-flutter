import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/blocs/user/user_bloc.dart';
import 'package:minibuddy/blocs/user/user_state.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('감정 상태')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final status = state.status;

            final flow = state.flow; // List<EmotionFlowModel> 타입

            final distribution =
                state.distribution; // EmotionDistributionModel 타입

            return _buildContent(
                status, flow, distribution); // flow와 distribution 전달
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
    UserStatusModel status,
    List<EmotionFlowModel> flow, // List<EmotionFlowModel>로 수정
    EmotionDistributionModel distribution,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 사용자 상태 텍스트 출력
        Text('우울 점수: ${status.depScore}'),
        Text('불안 점수: ${status.anxScore}'),
        Text('스트레스 점수: ${status.strScore}'),
        Text('기억력 점수: ${status.mciScore}'),
        Text('총 채팅 수: ${status.chatCount}'),
        const Divider(),

        // 감정 흐름 (Emotion Flow) 그래프 그리기
        const Text('감정 흐름 (날짜별 우울, 불안, 스트레스 점수)'),
        SizedBox(
          height: 200,
          child: CustomPaint(
            painter: EmotionFlowPainter(flow), // List<EmotionFlowModel> 전달
          ),
        ),
        const Divider(),

        // 감정 분포 (Emotion Distribution) 그래프 그리기
        const Text('감정 분포 (정상, 우울, 불안, 스트레스)'),
        SizedBox(
          height: 200,
          child: CustomPaint(
            painter: EmotionDistributionPainter(distribution),
          ),
        ),
      ],
    );
  }
}
