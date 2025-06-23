import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geolocation.g.dart';

@Riverpod(keepAlive: true)
class Location extends _$Location {
  get talker => null;

  @override
  Position? build() {
    return null;
  }

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

  Future<({double latitude, double longitude})> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always) {
      await requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition();
      state = position;
      return (
      longitude: position.longitude,
      latitude: position.latitude,
      );
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }
  }

  // double calculateDistanceDiffToCurrent({
  //   required double latitude,
  //   required double longitude,
  // }) {
  //   if (state == null) {
  //     talker.error('Current location null');
  //   }
  //
  //   if (latitude >= 90) {
  //     return 1000000;
  //   }
  //
  //   double diff = const Distance().as(
  //     LengthUnit.Meter,
  //     LatLng(latitude, longitude),
  //     LatLng(state!.latitude, state!.longitude),
  //   );
  //   return diff;
  // }
  //
  // double calculateDistanceDiff({
  //   required ({double latitude, double longitude}) position1,
  //   required ({double latitude, double longitude}) position2,
  // }) {
  //   double diff = const Distance().as(
  //     LengthUnit.Meter,
  //     LatLng(position1.latitude, position1.longitude),
  //     LatLng(position2.latitude, position2.longitude),
  //   );
  //   return diff;
  // }
}
