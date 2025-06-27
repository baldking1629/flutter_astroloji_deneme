import 'package:dreamscope/features/profile/data/models/user_profile_model.dart';
import 'package:sembast/sembast.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getUserProfile();
  Future<void> saveUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile();
}

class SembastProfileLocalDataSource implements ProfileLocalDataSource {
  final Database _database;
  final StoreRef<String, Map<String, dynamic>> _store;

  SembastProfileLocalDataSource(this._database)
      : _store = stringMapStoreFactory.store('user_profile');

  @override
  Future<UserProfileModel?> getUserProfile() async {
    final snapshots = await _store.find(_database);
    if (snapshots.isNotEmpty) {
      return UserProfileModel.fromJson(snapshots.first.value);
    }
    return null;
  }

  @override
  Future<void> saveUserProfile(UserProfileModel profile) async {
    // Sadece bir profil olacağı için 'default' key kullanıyoruz
    await _store.record('default').put(_database, profile.toJson());
  }

  @override
  Future<void> deleteUserProfile() async {
    await _store.record('default').delete(_database);
  }
}
