import 'package:intl/intl.dart';  // intl paketini import edin

class Weather {
  String sehir;
  String bolge;
  String ulke;
  double sicaklik;
  String durum;
  String icon;
  int nem;
  double ruzgar;
  double hissedilen;
  double uv;

  List<DailyForecast> dailyForecasts;

  Weather.fromMap(Map<String, dynamic> weatherMap)
      : sehir = weatherMap["location"]["name"] ?? "",
        bolge = weatherMap["location"]["region"] ?? "",
        ulke = weatherMap["location"]["country"] ?? "",
        sicaklik = weatherMap["current"]["temp_c"]?.toDouble() ?? 0.0,
        durum = _translateCondition(weatherMap["current"]["condition"]["text"]),
        icon = "https:${weatherMap["current"]["condition"]["icon"] ?? ""}",
        nem = weatherMap["current"]["humidity"] ?? 0,
        ruzgar = weatherMap["current"]["wind_kph"]?.toDouble() ?? 0.0,
        hissedilen = weatherMap["current"]["feelslike_c"]?.toDouble() ?? 0.0,
        uv = weatherMap["current"]["uv"]?.toDouble() ?? 0.0,
        dailyForecasts = (weatherMap["forecast"]["forecastday"] as List)
            .map((forecast) => DailyForecast.fromMap(forecast))
            .toList();

  static String _translateCondition(String condition) {
    String normalizedCondition = condition.trim().toLowerCase();
    return weatherConditionTranslation[normalizedCondition] ?? condition;
  }

  // Tarih formatını gün adına çevirme fonksiyonu
  static String getDayName(String date) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);  // Tarihi DateTime objesine çeviriyoruz
    return DateFormat('EEEE', 'tr_TR').format(parsedDate);  // Türkçe gün adı alıyoruz
  }
}

class DailyForecast {
  String tarih;
  String durum;
  String icon;
  double maxSicaklik;
  double minSicaklik;

  DailyForecast.fromMap(Map<String, dynamic> forecastMap)
      : tarih = forecastMap["date"] ?? "",
        durum = Weather._translateCondition(forecastMap["day"]["condition"]["text"]),
        icon = "https:${forecastMap["day"]["condition"]["icon"] ?? ""}",
        maxSicaklik = forecastMap["day"]["maxtemp_c"]?.toDouble() ?? 0.0,
        minSicaklik = forecastMap["day"]["mintemp_c"]?.toDouble() ?? 0.0;

  // Gün adı fonksiyonunu kullanarak tarih yerine gün adını döndüreceğiz
  String getFormattedDay() {
    return Weather.getDayName(tarih); // tarih bilgisini gün adına çeviriyoruz
  }
}

// Çeviri haritası
Map<String, String> weatherConditionTranslation = {
  "partly cloudy": "Parçalı bulutlu",
  "sunny": "Güneşli",
  "rain": "Yağmurlu",
  "cloudy": "Bulutlu",
  "patchy rain nearby": "Yakınlarda yer yer yağmur",
  "clear": "Açık",
  "mist": "Sisli",
  "snow": "Karlı",
  "thunderstorm": "Gök gürültülü",
  "moderate rain": "Orta şiddetli yağmur",
  "light rain": "Hafif yağmur",
  "heavy rain": "Şiddetli yağmur",
  "drizzle": "Çiseleme",
  "showers": "Yağmur",
  "light snow": "Hafif kar",
  "heavy snow": "Şiddetli kar",
  "fog": "Sis",
  "blizzard": "Kar fırtınası",
  "dust": "Toz",
  "sand": "Kum",
  "tornado": "Kasırga",
};
