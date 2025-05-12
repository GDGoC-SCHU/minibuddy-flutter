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
  Future<List<EmotionFlowModel>> getFlow() async {
    List<EmotionFlowModel>? result;

    await handleRequest<Map<String, dynamic>>(
      // 실제 응답 타입 명시
      context: context,
      fetch: fetchEmotionFlowRaw, // Raw 데이터 가져오기
      onSuccess: (responseData) {
        result = EmotionFlowModel.fromJsonList(responseData); // 모델 변환
        debugPrint('GET emotion flow: ${result?.length} items loaded');
      },
      retry: () => getFlow(),
    );

    return result ?? [];
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
