class UserStatusModel {
  final int depScore;
  final int anxScore;
  final int strScore;
  final int mciScore;
  final int chatCount;

  UserStatusModel({
    required this.depScore,
    required this.anxScore,
    required this.strScore,
    required this.mciScore,
    required this.chatCount,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return UserStatusModel(
      depScore: data['dep_score'],
      anxScore: data['anx_score'],
      strScore: data['str_score'],
      mciScore: data['mci_score'],
      chatCount: data['chat_count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'dep_score': depScore,
        'anx_score': anxScore,
        'str_score': strScore,
        'mci_score': mciScore,
        'chat_count': chatCount,
      };
}
