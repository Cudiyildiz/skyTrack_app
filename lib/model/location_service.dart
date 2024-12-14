import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<LocationDetail?> getDetailedLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get address information from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return LocationDetail(
          city: place.administrativeArea ?? "",
          district: place.subAdministrativeArea ?? "",
          neighborhood: place.subLocality ?? "",
          street: place.thoroughfare ?? "",
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
      return null;
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }
}

class LocationDetail {
  final String city;
  final String district;
  final String neighborhood;
  final String street;
  final double latitude;
  final double longitude;

  LocationDetail({
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.street,
    required this.latitude,
    required this.longitude,
  });

  String get fullAddress {
    return '$city, $district, $neighborhood';
  }

  String get coordinates {
    return '$latitude,$longitude';
  }
}