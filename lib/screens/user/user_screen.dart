import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // GoRouter 임포트
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
        title: const Text('Emotional Status'),
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
    );
  }

  Widget _buildContent(
    UserStatusModel status,
    List<EmotionFlowModel> flow,
    EmotionDistributionModel distribution,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalChats(status.chatCount), // Display total chats
          const SizedBox(height: 16),
          _buildScoreCards(status), // Display 4 score cards in 2x2 grid
          const SizedBox(height: 16),
          _buildFlowChart(flow), // Display emotion flow chart
          const SizedBox(height: 16),
          _buildDistributionChart(
              distribution), // Display emotion distribution chart
        ],
      ),
    );
  }

  // Display total chats at the top with center alignment
  Widget _buildTotalChats(int totalChats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          "In total, you've had $totalChats conversations",
          textAlign: TextAlign.center, // Center-align the text
          style: TextStyle(
            fontSize:
                constraints.maxWidth > 600 ? 30 : 25, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  // Display 4 score cards in a 2x2 grid
  Widget _buildScoreCards(UserStatusModel status) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildScoreCard('Depression', status.depScore, '/user/depression'),
        _buildScoreCard('Anxiety', status.anxScore, '/user/anxiety'),
        _buildScoreCard('Stress', status.strScore, '/user/stress'),
        _buildScoreCard('Memory', status.mciScore, '/user/memory'),
      ],
    );
  }

  // Create a score card for each category with improved UI
  Widget _buildScoreCard(String label, int score, String route) {
    return InkWell(
      onTap: () {
        // Navigate to the respective screen using GoRouter
        context.push(route); // Use GoRouter for navigation
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Emotion flow chart section
  Widget _buildFlowChart(List<EmotionFlowModel> flow) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📈 Emotion Flow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Emotion Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
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
