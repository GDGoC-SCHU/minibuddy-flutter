import 'package:flutter/material.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/models/history_models.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/utils/handle_request.dart';

class EmotionHistoryBuilder extends StatefulWidget {
  final String type; // "ANXIETY", "DEPRESSION", "STRESS"

  const EmotionHistoryBuilder({super.key, required this.type});

  @override
  State<EmotionHistoryBuilder> createState() => _EmotionHistoryBuilderState();
}

class _EmotionHistoryBuilderState extends State<EmotionHistoryBuilder> {
  final _repository = HistoryRepository(HistoryApi(ApiClient.instance));
  List<EmotionHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    handleRequest<List<EmotionHistory>>(
      context: context,
      fetch: () => _repository.getEmotionHistory(widget.type),
      onSuccess: (data) {
        setState(() => _history = data);
      },
      retry: _fetchHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (_, index) {
        final item = _history[index];
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
                Text(item.message, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  item.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
