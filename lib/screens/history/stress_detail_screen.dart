import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/blocs/history/history_bloc.dart';
import 'package:minibuddy/blocs/history/history_event.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/screens/history/emotion_history_builder.dart';
import 'package:minibuddy/utils/api_client.dart';

class StressDetailScreen extends StatelessWidget {
  const StressDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(
        HistoryRepository(HistoryApi(ApiClient.instance)),
      )..add(FetchEmotionHistory("STRESS")),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stress History'),
          automaticallyImplyLeading: true,
        ),
        body: EmotionHistoryBuilder(),
      ),
    );
  }
}
