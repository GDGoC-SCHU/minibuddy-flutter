import 'package:minibuddy/models/history_models.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class EmotionHistoryLoaded extends HistoryState {
  final List<EmotionHistory> data;

  EmotionHistoryLoaded(this.data);
}

class MemoryHistoryLoaded extends HistoryState {
  final List<MemoryHistory> data;

  MemoryHistoryLoaded(this.data);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
