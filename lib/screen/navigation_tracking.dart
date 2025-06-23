import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class NavigationTracking extends StatefulWidget {
  const NavigationTracking({super.key});

  @override
  State<StatefulWidget> createState() => NavigationTrackingState();
}

class NavigationTrackingState extends State<NavigationTracking>{
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.509513291985925, 127.10262143083467);
  static const LatLng destination = LatLng(37.4924731, 127.1187564);

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 14,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );

      setState(() {});
    });
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/navigation/truck_left.png").then(
            (icon) {
          currentLocationIcon = icon;
        }
    );
  }

  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: google_api_key,
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    if (result.points.isNotEmpty){
      result.points.forEach(
        (PointLatLng point)=> polylineCoordinates.add(
          LatLng(point.latitude, point.longitude)
        )
      );
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body:
      currentLocation == null
          ? const Center(
        child: Text("Loading"),
      ):
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
          // sourceLocation,
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 15,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: primaryColor,
            width: 6,
          ),
        },
        markers: {
          Marker(
              markerId: const MarkerId("currentLocation"),
              icon: currentLocationIcon,
              position:
              // sourceLocation),
              LatLng(currentLocation!.latitude!,
                  currentLocation!.longitude!)),
          const Marker(
              markerId: MarkerId("source"), position: sourceLocation),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),

    );
  }
}