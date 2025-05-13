import 'package:flutter/foundation.dart';
import 'package:minibuddy/models/history_models.dart';
import 'history_api.dart';

class HistoryRepository {
  final HistoryApi api;

  HistoryRepository(this.api);

  Future<List<EmotionHistory>> getEmotionHistory(String type) async {
    final raw = await api.fetchEmotionHistory(type);
    debugPrint('[HistoryRepository] Fetched emotion history for $type: \$raw');

    if (raw is! List) {
      throw Exception(
          '[HistoryRepository] Expected a list but got: \${raw.runtimeType}');
    }

    return raw
        .map((e) => EmotionHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MemoryHistory>> getMemoryHistory() async {
    final raw = await api.fetchMemoryHistory();
    debugPrint('[HistoryRepository] Fetched memory history: \$raw');

    if (raw is! List) {
      throw Exception(
          '[HistoryRepository] Expected a list but got: \${raw.runtimeType}');
    }

    return raw
        .map((e) => MemoryHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
