class EmotionDistributionModel {
  final int totalCount;
  final int normal;
  final int dep;
  final int anx;
  final int str;

  EmotionDistributionModel({
    required this.totalCount,
    required this.normal,
    required this.dep,
    required this.anx,
    required this.str,
  });

  factory EmotionDistributionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return EmotionDistributionModel(
      totalCount: data['total_count'],
      normal: data['normal'],
      dep: data['dep'],
      anx: data['anx'],
      str: data['str'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_count': totalCount,
        'normal': normal,
        'dep': dep,
        'anx': anx,
        'str': str,
      };
}
