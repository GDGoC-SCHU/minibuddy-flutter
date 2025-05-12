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

  factory EmotionFlowModel.fromJson(Map<String, dynamic> json) {
    return EmotionFlowModel(
      date: json['date'] ?? '', // null 값 처리
      depScore: json['dep_score'] ?? 0, // null 값 처리
      anxScore: json['anx_score'] ?? 0, // null 값 처리
      strScore: json['str_score'] ?? 0, // null 값 처리
    );
  }

  static List<EmotionFlowModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EmotionFlowModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'dep_score': depScore,
        'anx_score': anxScore,
        'str_score': strScore,
      };
}
