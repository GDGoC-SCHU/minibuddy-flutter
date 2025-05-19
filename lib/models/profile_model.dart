class Profile {
  final String nickname;
  final DateTime birthdate;
  final List<String> keywords;

  Profile({
    required this.nickname,
    required this.birthdate,
    required this.keywords,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Profile(
      nickname: data['nickname'],
      birthdate: DateTime.parse(data['birthdate']),
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }

  Profile copyWith({
    String? nickname,
    DateTime? birthdate,
    List<String>? keywords,
  }) {
    return Profile(
      nickname: nickname ?? this.nickname,
      birthdate: birthdate ?? this.birthdate,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'birthdate': birthdate.toIso8601String(),
        'keywords': keywords,
      };
}
