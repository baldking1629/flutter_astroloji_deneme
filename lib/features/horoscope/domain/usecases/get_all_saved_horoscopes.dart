import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/saved_horoscope_repository.dart';

class GetAllSavedHoroscopes {
  final SavedHoroscopeRepository repository;

  GetAllSavedHoroscopes(this.repository);

  Future<List<SavedHoroscope>> call() async {
    return await repository.getAllSavedHoroscopes();
  }
}
