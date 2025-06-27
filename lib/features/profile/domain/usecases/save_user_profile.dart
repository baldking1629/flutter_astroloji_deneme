import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';
import 'package:dreamscope/features/profile/domain/repositories/profile_repository.dart';

class SaveUserProfile {
  final ProfileRepository repository;
  SaveUserProfile(this.repository);

  Future<void> call(UserProfile profile) async {
    return repository.saveUserProfile(profile);
  }
}
