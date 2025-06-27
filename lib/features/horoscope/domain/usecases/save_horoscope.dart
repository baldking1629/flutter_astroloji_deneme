import 'package:dreamscope/features/horoscope/domain/entities/saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/saved_horoscope_repository.dart';

class SaveHoroscope {
  final SavedHoroscopeRepository repository;

  SaveHoroscope(this.repository);

  Future<void> call(SavedHoroscope horoscope) async {
    await repository.saveHoroscope(horoscope);
  }
}
