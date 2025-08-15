import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/metro_provider.dart';
import '../data/metro_data.dart';

class MetroMap extends StatefulWidget {
  const MetroMap({super.key});

  @override
  State<MetroMap> createState() => _MetroMapState();
}

class _MetroMapState extends State<MetroMap> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore center
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _createMarkers();
    _createPolylines();
  }

  void _createMarkers() {
    _markers = MetroData.stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: station.isInterchange ? 'Interchange Station' : null,
        ),
        icon: station.isInterchange 
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }).toSet();
  }

  void _createPolylines() {
    _polylines = MetroData.lines.map((line) {
      final points = line.stations
          .map((stationId) {
            try {
              return MetroData.stations.firstWhere((s) => s.id == stationId);
            } catch (e) {
              return null; // Station not found
            }
          })
          .where((station) => station != null)
          .map((station) => LatLng(station!.latitude, station.longitude))
          .toList();

      return Polyline(
        polylineId: PolylineId(line.id),
        points: points,
        color: line.color,
        width: 4,
        patterns: line.isOperational ? [] : [PatternItem.dash(10), PatternItem.gap(5)],
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MetroProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              // Map controller ready
            },
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),
        );
      },
    );
  }
}