import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/metro_provider.dart';
import '../data/metro_data.dart';
import '../models/metro_station.dart';

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
    _createPolylines();
  }

  void _updateMarkers(MetroProvider provider) {
    _markers = MetroData.stations.map((station) {
      // Get the primary line color for the marker
      final primaryLine = station.lines.first;
      
      // Determine marker color and info
      double markerHue;
      String lineInfo;
      
      // Check if this station is selected
      bool isFromStation = provider.fromStation?.id == station.id;
      bool isToStation = provider.toStation?.id == station.id;
      
      if (isFromStation) {
        markerHue = BitmapDescriptor.hueRed;
        lineInfo = 'FROM: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else if (isToStation) {
        markerHue = BitmapDescriptor.hueBlue;
        lineInfo = 'TO: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else if (station.isInterchange) {
        markerHue = BitmapDescriptor.hueOrange;
        lineInfo = 'Interchange: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else {
        switch (primaryLine) {
          case 'green':
            markerHue = BitmapDescriptor.hueGreen;
            lineInfo = 'Green Line';
            break;
          case 'purple':
            markerHue = BitmapDescriptor.hueViolet;
            lineInfo = 'Purple Line';
            break;
          case 'yellow':
            markerHue = BitmapDescriptor.hueYellow;
            lineInfo = 'Yellow Line';
            break;
          default:
            markerHue = BitmapDescriptor.hueBlue;
            lineInfo = 'Metro Line';
        }
      }

      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: lineInfo,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
        onTap: () => _onMarkerTapped(station),
      );
    }).toSet();
  }



  void _onMarkerTapped(MetroStation station) {
    final provider = Provider.of<MetroProvider>(context, listen: false);
    
    if (provider.fromStation == null) {
      // First click - set as 'from' station
      provider.setFromStation(station);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('From: ${station.name}. Tap another station for destination.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else if (provider.toStation == null && provider.fromStation!.id != station.id) {
      // Second click - set as 'to' station (if different from 'from')
      provider.setToStation(station);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('To: ${station.name}. Tap "Find Route" to plan your journey.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (provider.fromStation!.id == station.id) {
      // Clicked same station as 'from' - show message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This station is already selected as your starting point.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Both stations already selected - reset and start over
      provider.setFromStation(station);
      provider.setToStation(null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Route reset. From: ${station.name}. Tap another station for destination.'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
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
        // Update markers based on current provider state
        _updateMarkers(provider);
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              GoogleMap(
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
              // Legend overlay
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Metro Lines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildLegendItem(Colors.green, 'Green Line'),
                      _buildLegendItem(Colors.purple, 'Purple Line'),
                      _buildLegendItem(Colors.yellow[700]!, 'Yellow Line'),
                      _buildLegendItem(Colors.orange, 'Interchange'),
                      const Divider(height: 8),
                      _buildLegendItem(Colors.red, 'From Station'),
                      _buildLegendItem(Colors.blue, 'To Station'),
                    ],
                  ),
                ),
              ),
              // Instructions overlay
              if (provider.fromStation == null)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Tap any station on the map to select your starting point',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}