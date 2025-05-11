class UserProfile {
  final String email;
  final String name;
  final DateTime birthdate;
  final List<String> keywords;

  UserProfile({
    required this.email,
    required this.name,
    required this.birthdate,
    required this.keywords,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserProfile(
      email: data['email'] ?? '',
      name: data['name'],
      birthdate: DateTime.parse(data['birthdate']),
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'keywords': keywords,
    };
  }
}
