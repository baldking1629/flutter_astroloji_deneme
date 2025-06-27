import 'package:dreamscope/features/horoscope/domain/repositories/saved_horoscope_repository.dart';

class DeleteSavedHoroscope {
  final SavedHoroscopeRepository repository;

  DeleteSavedHoroscope(this.repository);

  Future<void> call(String id) async {
    await repository.deleteHoroscope(id);
  }
}
