import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String name,
    required DateTime birthDate,
    required String birthTime,
    required String birthPlace,
    required String zodiacSign,
    String? ascendant,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfile profile) => UserProfileModel(
        id: profile.id,
        name: profile.name,
        birthDate: profile.birthDate,
        birthTime: profile.birthTime,
        birthPlace: profile.birthPlace,
        zodiacSign: profile.zodiacSign,
        ascendant: profile.ascendant,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );
}

extension UserProfileModelExtension on UserProfileModel {
  UserProfile toEntity() => UserProfile(
        id: id,
        name: name,
        birthDate: birthDate,
        birthTime: birthTime,
        birthPlace: birthPlace,
        zodiacSign: zodiacSign,
        ascendant: ascendant,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
