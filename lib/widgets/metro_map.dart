import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/metro_provider.dart';
import '../data/metro_data.dart';
import '../models/metro_station.dart';
import '../utils/custom_marker_helper.dart';

class MetroMap extends StatefulWidget {
  const MetroMap({super.key});

  @override
  State<MetroMap> createState() => _MetroMapState();
}

class _MetroMapState extends State<MetroMap> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  // Line visibility toggles
  Map<String, bool> _lineVisibility = {
    'green': true,
    'purple': true,
    'yellow': true,
  };

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946), // Bangalore center
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _createPolylines();
    // Initialize markers with empty provider state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MetroProvider>(context, listen: false);
      _updateMarkers(provider);
    });
  }

  Future<void> _updateMarkers(MetroProvider provider) async {
    print('Updating markers for ${MetroData.stations.length} stations');
    print('Provider state - From: ${provider.fromStation?.name}, To: ${provider.toStation?.name}');
    
    final List<Marker> markers = [];
    
    for (final station in MetroData.stations) {
      // Check if any of the station's lines are visible
      bool isVisible = station.lines.any((lineId) => _lineVisibility[lineId] == true);
      
      // Always show selected stations regardless of line visibility
      bool isFromStation = provider.fromStation?.id == station.id;
      bool isToStation = provider.toStation?.id == station.id;
      
      if (!isVisible && !isFromStation && !isToStation) {
        continue; // Skip this station if its lines are hidden
      }
      
      // Create line info for tooltip
      String lineInfo;
      if (isFromStation) {
        lineInfo = 'FROM: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else if (isToStation) {
        lineInfo = 'TO: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else if (station.isInterchange) {
        lineInfo = 'Interchange: ${station.lines.map((lineId) => MetroData.lines.firstWhere((l) => l.id == lineId).name).join(', ')}';
      } else {
        final primaryLine = station.lines.first;
        final line = MetroData.lines.firstWhere((l) => l.id == primaryLine);
        lineInfo = '${line.name}';
      }
      
      // Create custom marker with smaller size
      final customIcon = await CustomMarkerHelper.createStationMarker(
        station,
        isFromStation: isFromStation,
        isToStation: isToStation,
        size: 40, // Much smaller size
      );
      
      final marker = Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: lineInfo,
        ),
        icon: customIcon,
        onTap: () => _onMarkerTapped(station),
      );
      
      markers.add(marker);
      print('Created custom marker for ${station.name}');
    }
    
    setState(() {
      _markers = markers.toSet();
    });
    
    print('Total custom markers created: ${_markers.length}');
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

  Widget _buildLineToggle(String label, String lineId, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _lineVisibility[lineId],
            onChanged: (bool? value) {
              setState(() {
                _lineVisibility[lineId] = value ?? false;
                _createPolylines(); // Recreate polylines
                // Recreate markers
                final provider = Provider.of<MetroProvider>(context, listen: false);
                _updateMarkers(provider);
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _createPolylines() {
    _polylines = MetroData.lines.where((line) => _lineVisibility[line.id] == true).map((line) {
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
        // Update markers based on current provider state (async)
        _updateMarkers(provider);
        
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              // Line toggles at the top
              Positioned(
                top: 10,
                left: 10,
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
                        'Show Lines',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildLineToggle('Green', 'green', Colors.green),
                      _buildLineToggle('Purple', 'purple', Colors.purple),
                      _buildLineToggle('Yellow', 'yellow', Colors.yellow[700]!),
                    ],
                  ),
                ),
              ),
              GoogleMap(
                initialCameraPosition: _initialPosition,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  print('Google Map created successfully!');
                  print('Markers on map: ${_markers.length}');
                  print('Polylines on map: ${_polylines.length}');
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