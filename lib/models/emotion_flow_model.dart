class EmotionFlowModel {
  final String date;
  final int depScore;
  final int anxScore;
  final int strScore;

  EmotionFlowModel({
    required this.date,
    required this.depScore,
    required this.anxScore,
    required this.strScore,
  });

  // 단일 JSON 객체 → 객체 변환 (팩토리 생성자)
  factory EmotionFlowModel.fromJson(Map<String, dynamic> json) {
    return EmotionFlowModel(
      date: (json['date'] as String?) ?? 'N/A', // 명시적 타입 캐스팅 + 기본값
      depScore: (json['dep_score'] as int?) ?? 0,
      anxScore: (json['anx_score'] as int?) ?? 0,
      strScore: (json['str_score'] as int?) ?? 0,
    );
  }

  // JSON 전체 응답 → 객체 리스트 변환 (정적 메서드)
  static List<EmotionFlowModel> fromJsonList(Map<String, dynamic> json) {
    // 1. 'data' 필드 추출 (타입 캐스팅 + null 처리)
    final rawData = json['data'] as List<dynamic>? ?? [];

    // 2. 각 항목을 안전하게 변환
    return rawData.map((item) {
      final data = item as Map<String, dynamic>? ?? {};
      return EmotionFlowModel.fromJson(data);
    }).toList();
  }

  // 객체 → JSON 변환 (스네이크 케이스 유지)
  Map<String, dynamic> toJson() => {
        'date': date,
        'dep_score': depScore,
        'anx_score': anxScore,
        'str_score': strScore,
      };
}
