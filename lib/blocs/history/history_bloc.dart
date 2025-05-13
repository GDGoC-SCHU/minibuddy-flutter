import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:minibuddy/blocs/history/history_status.dart';
import 'package:minibuddy/data/history/history_repository.dart';
import 'history_event.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc(this.repository) : super(HistoryInitial()) {
    on<FetchEmotionHistory>(_onFetchEmotionHistory);
    on<FetchMemoryHistory>(_onFetchMemoryHistory);
  }

  Future<void> _onFetchEmotionHistory(
      FetchEmotionHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final data = await repository.getEmotionHistory(event.type);
      debugPrint(
          '[HistoryBloc] Emotion history loaded for ${event.type}: \$data');
      emit(EmotionHistoryLoaded(data));
    } catch (e, stack) {
      debugPrint('[HistoryBloc] Error: $e\n$stack');

      emit(HistoryError('불러오기 실패: \$e'));
    }
  }

  Future<void> _onFetchMemoryHistory(
      FetchMemoryHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final data = await repository.getMemoryHistory();
      debugPrint('[HistoryBloc] Memory history loaded: \$data');
      emit(MemoryHistoryLoaded(data));
    } catch (e, stack) {
      debugPrint('[HistoryBloc] Error: \$e\n\$stack');
      emit(HistoryError('불러오기 실패: \$e'));
    }
  }
}
