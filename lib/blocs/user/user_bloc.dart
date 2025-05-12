import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minibuddy/blocs/user/user_event.dart';
import 'package:minibuddy/blocs/user/user_state.dart';
import 'package:minibuddy/data/user/user_repository.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'package:minibuddy/models/user_status_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUserData>((event, emit) async {
      emit(UserLoading());
      try {
        // 여러 API 호출을 병렬로 처리
        final results = await Future.wait([
          repository.getStatus(),
          repository.getFlow(),
          repository.getDistribution(),
        ]);

        final status = results[0] as UserStatusModel;
        final flow = results[1] as List<EmotionFlowModel>;
        final dist = results[2] as EmotionDistributionModel;

        // 데이터 로드 성공 시 상태를 UserLoaded로 업데이트
        emit(UserLoaded(status: status, flow: flow, distribution: dist));
      } catch (e, stack) {
        debugPrint('❌ UserBloc LoadUserData 실패: $e');
        debugPrint('📍 $stack');
        // 에러 발생 시 UserError 상태로 에러 메시지를 전달
        emit(UserError(message: e.toString()));
      }
    });
  }
}
