import 'package:dreamscope/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:dreamscope/features/profile/data/models/user_profile_model.dart';
import 'package:dreamscope/features/profile/domain/entities/user_profile.dart';
import 'package:dreamscope/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfile?> getUserProfile() async {
    final model = await localDataSource.getUserProfile();
    return model?.toEntity();
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return localDataSource.saveUserProfile(model);
  }

  @override
  Future<void> deleteUserProfile() async {
    return localDataSource.deleteUserProfile();
  }
}
