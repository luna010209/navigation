import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

Future<LocationPermission> requestPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission != LocationPermission.always) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied");
    }
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }
  }
  return await Geolocator.checkPermission();
}

Future<LatLng> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission != LocationPermission.always) {
    await requestPermission();
  }
  try {
    Position position = await Geolocator.getCurrentPosition();
    // state = position;
    return LatLng(position.latitude, position.longitude);
  } catch (error, stackTrace) {
    return Future.error(error, stackTrace);
  }
}