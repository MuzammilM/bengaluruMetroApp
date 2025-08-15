import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MetroMapTest extends StatefulWidget {
  const MetroMapTest({super.key});

  @override
  State<MetroMapTest> createState() => _MetroMapTestState();
}

class _MetroMapTestState extends State<MetroMapTest> {
  Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore center
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _createTestMarkers();
  }

  void _createTestMarkers() {
    _markers = {
      // Test Green marker
      Marker(
        markerId: const MarkerId('test_green'),
        position: const LatLng(12.9716, 77.5946),
        infoWindow: const InfoWindow(
          title: 'Test Green Station',
          snippet: 'Green Line Test',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      // Test Purple marker
      Marker(
        markerId: const MarkerId('test_purple'),
        position: const LatLng(12.9800, 77.6000),
        infoWindow: const InfoWindow(
          title: 'Test Purple Station',
          snippet: 'Purple Line Test',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
      // Test Yellow marker
      Marker(
        markerId: const MarkerId('test_yellow'),
        position: const LatLng(12.9600, 77.5800),
        infoWindow: const InfoWindow(
          title: 'Test Yellow Station',
          snippet: 'Yellow Line Test',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ),
      // Test Orange marker
      Marker(
        markerId: const MarkerId('test_orange'),
        position: const LatLng(12.9500, 77.5700),
        infoWindow: const InfoWindow(
          title: 'Test Orange Station',
          snippet: 'Interchange Test',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: GoogleMap(
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          print('Test Google Map created with ${_markers.length} markers');
        },
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}