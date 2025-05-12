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
      appBar: AppBar(
        title: const Text('Emotional Status Analysis'),
        elevation: 0, // Remove the app bar shadow
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return _buildContent(
              state.status,
              state.flow,
              state.distribution,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
    UserStatusModel status,
    List<EmotionFlowModel> flow,
    EmotionDistributionModel distribution,
  ) {
    return SingleChildScrollView(
      // Scrollable content area
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatusCard(status),
          const SizedBox(height: 12),
          _buildFlowChart(flow),
          const SizedBox(height: 12),
          _buildDistributionChart(distribution),
        ],
      ),
    );
  }

  // Status display card
  Widget _buildStatusCard(UserStatusModel status) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💬 User Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow('Depression Score', status.depScore),
            _buildStatusRow('Anxiety Score', status.anxScore),
            _buildStatusRow('Stress Score', status.strScore),
            _buildStatusRow('Memory Score', status.mciScore),
            _buildStatusRow('Total Chats', status.chatCount),
          ],
        ),
      ),
    );
  }

  // Common status row widget
  Widget _buildStatusRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Emotion flow chart section
  Widget _buildFlowChart(List<EmotionFlowModel> flow) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📈 Emotion Flow',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
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

  // Emotion distribution chart section
  Widget _buildDistributionChart(EmotionDistributionModel distribution) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Emotion Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
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
