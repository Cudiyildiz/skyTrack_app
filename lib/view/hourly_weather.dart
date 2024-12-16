import 'package:flutter/material.dart';

class HourlyWeather extends StatefulWidget {
  final List<dynamic> hourlyData;

  const HourlyWeather({required this.hourlyData, Key? key}) : super(key: key);

  @override
  State<HourlyWeather> createState() => _HourlyWeatherState();
}

class _HourlyWeatherState extends State<HourlyWeather> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: _isExpanded ? 300 : 80,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Saatlik Hava Durumu",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: 24,
                ),
                if (_isExpanded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.hourlyData.length,
                      itemBuilder: (context, index) {
                        final hourData = widget.hourlyData[index]; // HourlyForecast türünde

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                hourData.time.split(" ")[1], // Saat bilgisi
                                style: const TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Image.network(
                                    hourData.icon, // İkon alanına doğrudan erişim
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${hourData.tempC}°C", // Sıcaklık
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Text(
                                "${hourData.precipMm} mm", // Yağış miktarı
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
