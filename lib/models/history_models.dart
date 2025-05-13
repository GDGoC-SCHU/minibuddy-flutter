class EmotionHistory {
  final String date;
  final String message;

  EmotionHistory({
    required this.date,
    required this.message,
  });

  factory EmotionHistory.fromJson(Map<String, dynamic> json) {
    return EmotionHistory(
      date: json['date'],
      message: json['message'],
    );
  }
}

class MemoryHistory {
  final String date;
  final String question;
  final String answer;
  final String mciReason;

  MemoryHistory({
    required this.date,
    required this.question,
    required this.answer,
    required this.mciReason,
  });

  factory MemoryHistory.fromJson(Map<String, dynamic> json) {
    return MemoryHistory(
      date: json['date'],
      question: json['question'],
      answer: json['answer'],
      mciReason: json['mci_reason'] ?? json['mciReason'] ?? '',
    );
  }
}
