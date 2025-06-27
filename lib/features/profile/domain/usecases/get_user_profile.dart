import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';
import 'package:dreamscope/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;
  GetUserProfile(this.repository);

  Future<UserProfile?> call() async {
    return repository.getUserProfile();
  }
}
