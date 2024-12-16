import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skytrack_app/model/weather.dart';
import 'package:skytrack_app/model/weather_service.dart';
import '../model/location_service.dart';
import 'hourly_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationDetail? locationDetail;
  Weather? currentWeather;
  final WeatherService weatherService = WeatherService();
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    fetchLocationAndWeather();
  }

  Future<void> fetchLocationAndWeather() async {
    try {
      final location = await locationService.getDetailedLocation();
      if (location != null) {
        final weather = await weatherService.fetchWeatherByCoordinates(
          location.latitude,
          location.longitude,
        );
        setState(() {
          locationDetail = location;
          currentWeather = weather;
        });
      } else {
        final weather = await weatherService.fetchWeatherByCoordinates(41.0082, 28.9784);
        setState(() {
          currentWeather = weather;
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Hava Durumu",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: currentWeather == null
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.blue],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (locationDetail != null) ...[
                            Text(
                              locationDetail!.city,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "${locationDetail!.district}, ${locationDetail!.neighborhood}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentWeather!.sicaklik.round()}',
                                style: const TextStyle(
                                    fontSize: 42, color: Colors.white),
                              ),
                              Baseline(
                                baseline: 24,
                                baselineType: TextBaseline.alphabetic,
                                child: Text(
                                  '°C',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentWeather!.durum,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${(currentWeather!.ruzgar).round()} km/s",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          Image.network(currentWeather!.icon),
                          Text(
                            "Hissedilen Sıcaklık: ${(currentWeather!.hissedilen).round()}°C",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Image.asset(
                            "asset/image/humidity.png",
                            height: 15,
                            width: 15,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "${(currentWeather!.nem)}%",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              HourlyWeather(hourlyData: currentWeather!.hourlyData),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: currentWeather!.dailyForecasts.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox.shrink();
                    }
                    final forecast = currentWeather!.dailyForecasts[index];
                    String dayName = forecast.getFormattedDay();
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0x97CBE1FF),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ListTile(
                            leading: Image.network(forecast.icon),
                            title: Text(dayName),
                            subtitle: Text(
                                "${forecast.durum}, ${(forecast.minSicaklik).round()}°C - ${(forecast.maxSicaklik).round()}°C"),
                            tileColor: Colors.transparent,
                            selectedTileColor: Colors.blue.shade100,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
