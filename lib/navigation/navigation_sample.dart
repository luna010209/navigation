import 'package:flutter/material.dart';
import 'package:google_map/navigation/current_location.dart';
import 'package:google_map/navigation/location_utils.dart';
import 'package:google_map/navigation/start_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  // 예시: Petronas Twin Towers
  static const LatLng sourceLocation = LatLng(3.1377107,101.6778941);
  // 예시: Merdeka Square (Kuala Lumpur City Centre, 50050 Kuala Lumpur, Federal Territory of Kuala Lumpur, Malaysia)
  static const LatLng destination = LatLng(3.1490926,101.6833594);

  // 경로는 백엔드를 통해 결과 조회
  final String polylinePoints =
      // "itbRgeskRp@jAFXATKRQPWNm@^[HWA[Q}AgA{BeBu@_@WG_@Eu@G]Ou@k@]K[IyBeAkBcAc@U{@i@UUa@q@[_ASmBo@uG_A}GSeBq@gF[uA_@u@o@q@[Ss@[y@U_AQsD}@_@C]@QDEDSFY?KCc@DkAXuBT}AFk@Ac@Io@Em@Q[MM@[CmASgBS}@Uo@M}Ba@cFu@DSvDj@lDXhBTfBXbAVZLNLh@HhAPn@FZ@n@CrDa@v@SRId@Yj@i@d@y@L[TiAZ}BnAgJLeAV}ARy@Vq@PYvAgBrFaHp@kALs@hB_JTcA?]ASOeAGOUG[Qk@c@e@g@MQCIeAi@uBkAa@U_@Ke@IeAIg@JeALULQNiAxAk@|@oA~BuAfCqApCw@|Aa@dAEz@Cl@?n@?n@FZFT?LIJUEGODoBGg@BOFq@Do@LOh@oA";
      "e{cRc_rkR_At@sAt@i@Pi@Ea@MSk@Aa@Lm@JS~@gA|@iAA??AAE_BYc@@m@?[KMSGe@AWIa@GOKEW@]Ja@PQL[Py@j@mAlAQRMDC@FYFY^gA\\s@r@gAbDqDTU\\GXCLGFIDK@GGECAECGCI@UJOJO?eArAi@d@kBfBiC`CkA`AuAv@q@ViBh@cBTsABm@Cw@Kk@Mk@Sg@Se@[k@e@u@q@sAsA_DwCi@Oc@Su@[oAW[@m@MaAQeAS_@UQe@AQBUFSHQnAcAhByA";

  @override
  void initState() {
    super.initState();
    _decodePolyline();

  }

  void _decodePolyline() {
    PolylinePoints polylinePointsDecoder = PolylinePoints();
    List<PointLatLng> result = polylinePointsDecoder.decodePolyline(polylinePoints);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId("overview"),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polyline Example')),
      body:
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _polylineCoordinates.isNotEmpty ? calculateCentroid(_polylineCoordinates) : sourceLocation, // fallback Seoul
          zoom: 15,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        polylines: _polylines,
        markers: {
          const Marker(
              markerId: MarkerId("source"), position: sourceLocation),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () async {
          try {
            // LatLng currentLocation = (await getCurrentLocation()) as LatLng;
            await launchNavigation(
              source: //currentLocation,
              sourceLocation,
              destination: destination,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch Google Maps')),
            );
          }
        }
      ),
    );
  }
}
