import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

LatLng calculateCentroid(List<LatLng> points) {
  if (points.isEmpty) {
    throw ArgumentError('Point list must not be empty');
  }

  double x = 0;
  double y = 0;
  double z = 0;

  for (var point in points) {
    double latRad = radians(point.latitude);
    double lonRad = radians(point.longitude);

    x += cos(latRad) * cos(lonRad);
    y += cos(latRad) * sin(lonRad);
    z += sin(latRad);
  }

  int total = points.length;
  x /= total;
  y /= total;
  z /= total;

  double centralLon = atan2(y, x);
  double centralSqrt = sqrt(x * x + y * y);
  double centralLat = atan2(z, centralSqrt);

  return LatLng(degrees(centralLat), degrees(centralLon));
}

double radians(double degree) => degree * pi / 180;
double degrees(double rad) => rad * 180 / pi;
