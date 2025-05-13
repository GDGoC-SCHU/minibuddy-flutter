import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/blocs/history/history_bloc.dart';
import 'package:minibuddy/blocs/history/history_event.dart';
import 'package:minibuddy/blocs/history/history_status.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/utils/api_client.dart';

class AnxietyDetailScreen extends StatelessWidget {
  const AnxietyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(
        HistoryRepository(HistoryApi(ApiClient.instance)),
      )..add(FetchEmotionHistory("ANXIETY")),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('불안감 기록'),
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmotionHistoryLoaded) {
              final history = state.data;

              if (history.isEmpty) {
                return const Center(child: Text("불안감 기록이 없습니다."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (_, index) {
                  final item = history[index];
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.message,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            item.date,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is HistoryError) {
              return Center(child: Text('오류: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
