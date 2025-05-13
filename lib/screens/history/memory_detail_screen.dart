import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/blocs/history/history_bloc.dart';
import 'package:minibuddy/blocs/history/history_event.dart';
import 'package:minibuddy/blocs/history/history_status.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/utils/api_client.dart';

class MemoryDetailScreen extends StatelessWidget {
  const MemoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryBloc(
        HistoryRepository(HistoryApi(ApiClient.instance)),
      )..add(FetchMemoryHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Memory Check History'),
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MemoryHistoryLoaded) {
              final history = state.data;

              if (history.isEmpty) {
                return const Center(child: Text("No memory history found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (_, index) {
                  final item = history[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q: ${item.question}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('A: ${item.answer}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('🧠 ${item.mciReason}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(item.date,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                },
              );
            } else if (state is HistoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
