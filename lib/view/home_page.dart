import 'package:flutter/material.dart';
import 'package:skytrack_app/model/weather.dart';
import 'package:skytrack_app/model/weather_service.dart';
import '../model/location_service.dart';

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
        // Konum alınamazsa varsayılan koordinatları kullan (İstanbul)
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
        title: const Text("Hava Durumu",style: TextStyle(color: Colors.white),),
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
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
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        Text(
                          "${locationDetail!.district}, ${locationDetail!.neighborhood}",
                          style: const TextStyle(fontSize: 16,color: Colors.white70),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Text(
                        "${(currentWeather!.sicaklik).round()}°C",
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                      Image.network(currentWeather!.icon),
                      Text(
                        currentWeather!.durum,
                        style: const TextStyle(fontSize: 20,color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: currentWeather!.dailyForecasts.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SizedBox.shrink();
                    }
                    final forecast = currentWeather!.dailyForecasts[index];
                    String dayName = forecast.getFormattedDay();
                    return Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50), // Köşe yuvarlama
                          color: Color(0x97CBE1FF), // Arka plan rengi
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50), // ListTile'ın içeriği de yuvarlanmalı
                          child: ListTile(
                            leading: Image.network(forecast.icon),
                            title: Text(dayName),
                            subtitle: Text(
                                "${forecast.durum}, ${(forecast.minSicaklik).round()}°C - ${(forecast.maxSicaklik).round()}°C"),
                            tileColor: Colors.transparent, // İçerik için şeffaf arka plan
                            selectedTileColor: Colors.blue.shade100, // Seçilen tile rengi
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