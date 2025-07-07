class AscendantCalculatorService {
  static const List<String> _zodiacSigns = [
    'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo',
    'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'
  ];

  /// Basit yükselen burç hesaplama
  /// Gerçek astroloji hesaplaması çok karmaşık olduğu için, 
  /// doğum saati ve güneş burcuna göre basitleştirilmiş bir hesaplama yapıyoruz
  static String? calculateAscendant({
    required String sunSign,
    required String birthTime, // "HH:mm" formatında
    DateTime? birthDate,
  }) {
    try {
      // Doğum saatini parse et
      final timeParts = birthTime.split(':');
      if (timeParts.length != 2) return null;
      
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      // Saat 0-23 arası olmalı
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      
      // Güneş burcunun indeksini bul
      final sunSignIndex = _zodiacSigns.indexOf(sunSign.toLowerCase());
      if (sunSignIndex == -1) return null;
      
      // Yükselen burç hesaplama
      // Her 2 saatte bir burç değişir (24 saat / 12 burç = 2 saat)
      // Doğum saatine göre offset hesapla
      final hourOffset = (hour / 2).floor();
      
      // Doğum tarihine göre ek offset (mevsimsel değişim için)
      int dateOffset = 0;
      if (birthDate != null) {
        // Yılın hangi ayında doğduğuna göre küçük bir offset ekle
        dateOffset = (birthDate.month / 3).floor();
      }
      
      // Yükselen burç indeksini hesapla
      int ascendantIndex = (sunSignIndex + hourOffset + dateOffset) % 12;
      
      return _zodiacSigns[ascendantIndex];
    } catch (e) {
      return null;
    }
  }

  /// Güneş burcunu doğum tarihine göre hesapla
  static String calculateSunSign(DateTime birthDate) {
    final month = birthDate.month;
    final day = birthDate.day;

    // Burç tarih aralıkları
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'aries';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'taurus';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'gemini';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'leo';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'virgo';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'libra';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'scorpio';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'sagittarius';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'capricorn';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'aquarius';
    } else {
      return 'pisces';
    }
  }

  /// Burç adını Türkçe'ye çevir
  static String getSignNameInTurkish(String signKey) {
    const Map<String, String> signNames = {
      'aries': 'Koç',
      'taurus': 'Boğa',
      'gemini': 'İkizler',
      'cancer': 'Yengeç',
      'leo': 'Aslan',
      'virgo': 'Başak',
      'libra': 'Terazi',
      'scorpio': 'Akrep',
      'sagittarius': 'Yay',
      'capricorn': 'Oğlak',
      'aquarius': 'Kova',
      'pisces': 'Balık',
    };
    return signNames[signKey] ?? signKey;
  }

  /// Yükselen burç hakkında kısa açıklama
  static String getAscendantDescription(String ascendantSign) {
    const Map<String, String> descriptions = {
      'aries': 'Enerjik, cesur ve girişimci bir görünüm sergilersiniz. İnsanlar sizi dinamik ve lider ruhlu biri olarak görür.',
      'taurus': 'Sakin, güvenilir ve pratik bir izlenim bırakırsınız. İnsanlar sizi istikrarlı ve güvenilir biri olarak algılar.',
      'gemini': 'Zeki, meraklı ve iletişim yeteneği güçlü görünürsünüz. İnsanlar sizi çok yönlü ve eğlenceli bulur.',
      'cancer': 'Şefkatli, koruyucu ve duygusal bir hava yayarsınız. İnsanlar sizi anlayışlı ve empati sahibi görür.',
      'leo': 'Karizmatik, özgüvenli ve dramatik bir görünümünüz var. İnsanlar sizi çekici ve etkileyici bulur.',
      'virgo': 'Düzenli, detayc ve mükemmeliyetçi bir izlenim bırakırsınız. İnsanlar sizi titiz ve güvenilir görür.',
      'libra': 'Zarif, diplomatik ve uyumlu görünürsünüz. İnsanlar sizi estetik ve adil biri olarak algılar.',
      'scorpio': 'Gizemli, yoğun ve magnetik bir aura yayarsınız. İnsanlar sizi derin ve etkileyici bulur.',
      'sagittarius': 'Özgür ruhlu, optimist ve maceraperest görünürsünüz. İnsanlar sizi neşeli ve açık fikirli görür.',
      'capricorn': 'Ciddi, disiplinli ve hedef odaklı bir izlenim bırakırsınız. İnsanlar sizi sorumlu ve güvenilir görür.',
      'aquarius': 'Özgün, bağımsız ve vizyoner görünürsünüz. İnsanlar sizi farklı ve yenilikçi bulur.',
      'pisces': 'Rüyacı, yaratıc ve empatik bir hava yayarsınız. İnsanlar sizi duyarlı ve sezgisel görür.',
    };
    return descriptions[ascendantSign] ?? 'Yükselen burcunuz kişiliğinizin dış yansımasını etkiler.';
  }
}