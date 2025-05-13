import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HistoryApi {
  final Dio dio;

  HistoryApi(this.dio);

  Future<List<dynamic>> fetchEmotionHistory(String type) async {
    final response = await dio.get('/api/user/history', queryParameters: {
      'type': type,
    });
    debugPrint('[DEBUG] full response = ${response.data}');

    final data = response.data['data'];
    if (data is! List) {
      throw Exception(
          'Expected list in response.data["data"], got: ${data.runtimeType}');
    }

    return data;
  }

  Future<List<dynamic>> fetchMemoryHistory() async {
    final response = await dio.get('/api/user/history/memory');
    final data = response.data['data'];
    if (data is! List) {
      throw Exception(
          'Expected list in response.data["data"], got: ${data.runtimeType}');
    }
    return data;
  }
}
