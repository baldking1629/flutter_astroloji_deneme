import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';

class SavedHoroscopeModel {
  final String id;
  final String zodiacSign;
  final String period;
  final String content;
  final DateTime createdAt;
  final String? folderId;
  final String? folderName;

  const SavedHoroscopeModel({
    required this.id,
    required this.zodiacSign,
    required this.period,
    required this.content,
    required this.createdAt,
    this.folderId,
    this.folderName,
  });

  factory SavedHoroscopeModel.fromJson(Map<String, dynamic> json) {
    return SavedHoroscopeModel(
      id: json['id'] as String,
      zodiacSign: json['zodiacSign'] as String,
      period: json['period'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      folderId: json['folderId'] as String?,
      folderName: json['folderName'] as String?,
    );
  }

  factory SavedHoroscopeModel.fromEntity(SavedHoroscope entity) {
    return SavedHoroscopeModel(
      id: entity.id,
      zodiacSign: entity.zodiacSign,
      period: entity.period,
      content: entity.content,
      createdAt: entity.createdAt,
      folderId: entity.folderId,
      folderName: entity.folderName,
    );
  }

  SavedHoroscopeModel copyWith({
    String? id,
    String? zodiacSign,
    String? period,
    String? content,
    DateTime? createdAt,
    String? folderId,
    String? folderName,
  }) {
    return SavedHoroscopeModel(
      id: id ?? this.id,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      period: period ?? this.period,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zodiacSign': zodiacSign,
      'period': period,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'folderId': folderId,
      'folderName': folderName,
    };
  }

  SavedHoroscope toEntity() {
    return SavedHoroscope(
      id: id,
      zodiacSign: zodiacSign,
      period: period,
      content: content,
      createdAt: createdAt,
      folderId: folderId,
      folderName: folderName,
    );
  }
}
