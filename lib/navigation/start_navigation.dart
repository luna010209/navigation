import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> launchNavigation({
  required LatLng source,
  required LatLng destination,
}) async {
  final Uri googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
        '&origin=${source.latitude},${source.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&travelmode=driving&dir_action=navigate',
  );

  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch Google Maps';
  }
}
