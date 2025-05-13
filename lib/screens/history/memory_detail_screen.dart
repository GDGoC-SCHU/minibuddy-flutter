import 'package:flutter/material.dart';
import 'package:minibuddy/data/history/history_api.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'package:minibuddy/models/history_models.dart';
import 'package:minibuddy/utils/api_client.dart';
import 'package:minibuddy/utils/handle_request.dart';

class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({super.key});

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  final _repository = HistoryRepository(HistoryApi(ApiClient.instance));
  List<MemoryHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 뒤로가기로 복귀 시 로딩이 꺼지지 않는 문제 방지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent == true && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _fetchHistory() {
    setState(() => _isLoading = true);
    handleRequest<List<MemoryHistory>>(
      context: context,
      fetch: () => _repository.getMemoryHistory(),
      onSuccess: (data) {
        setState(() {
          _history = data;
          _isLoading = false;
        });
      },
      retry: () {
        setState(() => _isLoading = false); // 실패 후 복귀 시 false 처리
        _fetchHistory(); // 그리고 재시도
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Check History'),
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (_, index) {
                final item = _history[index];
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
            ),
    );
  }
}
