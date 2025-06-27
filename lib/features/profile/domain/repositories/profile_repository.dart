import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Future<void> deleteUserProfile();
}
