abstract class HistoryEvent {}

class FetchEmotionHistory extends HistoryEvent {
  final String type; // "DEPRESSION", "STRESS", "ANXIETY"
  FetchEmotionHistory(this.type);
}

class FetchMemoryHistory extends HistoryEvent {}
