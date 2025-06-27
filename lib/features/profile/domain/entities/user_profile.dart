import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required DateTime birthDate,
    required String birthTime,
    required String birthPlace,
    required String zodiacSign,
    String? ascendant,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;
}
