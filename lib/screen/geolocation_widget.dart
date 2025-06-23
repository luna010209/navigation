import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map/screen/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';  // your provider file

class GeolocationWidget extends ConsumerWidget {
  const GeolocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider
    final position = ref.watch(locationProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: position == null
          ? const Center(
        child: Text("Loading"),
      ):
          GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
          // sourceLocation,
          LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
              markerId: const MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(position.latitude,position.longitude)),
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          // Call getCurrentLocation on the notifier
          await ref.read(locationProvider.notifier).getCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
