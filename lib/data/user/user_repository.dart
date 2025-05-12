import 'package:flutter/material.dart';
import 'package:minibuddy/data/user/user_api.dart';
import 'package:minibuddy/models/user_status_model.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'package:minibuddy/utils/handle_request.dart';

class UserRepository {
  final BuildContext context;

  UserRepository(this.context);

  // 사용자 상태 조회
  Future<UserStatusModel> getStatus() async {
    UserStatusModel? result;

    await handleRequest<UserStatusModel>(
      context: context,
      fetch: fetchUserStatus, // API 호출 함수
      onSuccess: (data) {
        result = data;
        debugPrint('GET user status: ${result?.toJson()}');
      },
      retry: () => getStatus(),
    );

    return result!; // null이 올 수 없게 보장된 흐름
  }

  // 감정 흐름 조회
  Future<EmotionFlowModel> getFlow() async {
    EmotionFlowModel? result;

    await handleRequest<EmotionFlowModel>(
      context: context,
      fetch: fetchEmotionFlow, // API 호출 함수
      onSuccess: (data) {
        result = data;
        debugPrint('🙌GET emotion flow: ${result?.toJson()}');
      },
      retry: () => getFlow(),
    );

    return result!; // null이 올 수 없게 보장된 흐름
  }

  // 감정 분포 조회
  Future<EmotionDistributionModel> getDistribution() async {
    EmotionDistributionModel? result;

    await handleRequest<EmotionDistributionModel>(
      context: context,
      fetch: fetchEmotionDistribution, // API 호출 함수
      onSuccess: (data) {
        result = data;
        debugPrint('GET emotion distribution: ${result?.toJson()}');
      },
      retry: () => getDistribution(),
    );

    return result!; // null이 올 수 없게 보장된 흐름
  }
}
