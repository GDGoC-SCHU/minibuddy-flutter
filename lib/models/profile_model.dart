class Profile {
  final String email;
  final String name;
  final DateTime birthdate;
  final List<String> keywords;

  Profile({
    required this.email,
    required this.name,
    required this.birthdate,
    required this.keywords,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Profile(
      email: data['email'] ?? '',
      name: data['name'],
      birthdate: DateTime.parse(data['birthdate']),
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }

  Profile copyWith({
    String? name,
    DateTime? birthdate,
    List<String>? keywords,
  }) {
    return Profile(
      email: email,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'birthdate': birthdate.toIso8601String(),
        'keywords': keywords,
      };
}
