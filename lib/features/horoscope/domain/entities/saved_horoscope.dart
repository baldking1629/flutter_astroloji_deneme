class SavedHoroscope {
  final String id;
  final String zodiacSign;
  final String period; // daily, weekly, monthly
  final String content;
  final DateTime createdAt;
  final String? folderId;
  final String? folderName;

  const SavedHoroscope({
    required this.id,
    required this.zodiacSign,
    required this.period,
    required this.content,
    required this.createdAt,
    this.folderId,
    this.folderName,
  });

  SavedHoroscope copyWith({
    String? id,
    String? zodiacSign,
    String? period,
    String? content,
    DateTime? createdAt,
    String? folderId,
    String? folderName,
  }) {
    return SavedHoroscope(
      id: id ?? this.id,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      period: period ?? this.period,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedHoroscope && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
