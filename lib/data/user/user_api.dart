import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:minibuddy/models/emotion_distribution_model.dart';
import 'package:minibuddy/models/emotion_flow_model.dart';
import 'package:minibuddy/models/user_status_model.dart';
import 'package:minibuddy/utils/api_client.dart';

final Dio dio = ApiClient.instance;

// 사용자 상태 조회
Future<UserStatusModel> fetchUserStatus() async {
  try {
    final res = await dio.get('/api/user/status');
    return UserStatusModel.fromJson(res.data);
  } on DioException catch (e) {
    rethrow;
  }
}

// 감정 흐름 조회
Future<EmotionFlowModel> fetchEmotionFlow() async {
  try {
    final res = await dio.get('/api/user/emotion/flow');
    return EmotionFlowModel.fromJson(res.data);
  } on DioException catch (e) {
    rethrow;
  }
}

// 감정 분포 조회
Future<EmotionDistributionModel> fetchEmotionDistribution() async {
  try {
    final res = await dio.get('/api/user/emotion/distribution');
    return EmotionDistributionModel.fromJson(res.data);
  } on DioException catch (e) {
    rethrow;
  }
}
