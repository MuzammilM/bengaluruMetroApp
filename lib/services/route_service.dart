import '../models/metro_station.dart';
import '../data/metro_data.dart';

class RouteService {
  Future<JourneyRoute> findRoute(MetroStation from, MetroStation to) async {
    // Simple pathfinding algorithm for metro routes
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    
    // Check if stations are on the same line
    final commonLines = from.lines.where((line) => to.lines.contains(line)).toList();
    
    if (commonLines.isNotEmpty) {
      // Direct route on same line
      return _createDirectRoute(from, to, commonLines.first);
    } else {
      // Need interchange
      return _createInterchangeRoute(from, to);
    }
  }

  JourneyRoute _createDirectRoute(MetroStation from, MetroStation to, String lineId) {
    final line = MetroData.lines.firstWhere((l) => l.id == lineId);
    final fromIndex = line.stations.indexOf(from.id);
    final toIndex = line.stations.indexOf(to.id);
    
    final stationCount = (toIndex - fromIndex).abs();
    final estimatedTime = Duration(minutes: stationCount * 2 + 5); // 2 min per station + 5 min buffer
    
    return JourneyRoute(
      stations: [from, to],
      instructions: [
        'Board ${line.name} at ${from.name}',
        'Travel ${stationCount} stations',
        'Alight at ${to.name}'
      ],
      totalStations: stationCount,
      estimatedTime: estimatedTime,
    );
  }

  JourneyRoute _createInterchangeRoute(MetroStation from, MetroStation to) {
    // Find interchange station (simplified - using RV Road as main interchange)
    final interchangeStation = MetroData.stations.firstWhere(
      (station) => station.id == 'rashtreeya_vidyalaya_road'
    );
    
    final estimatedTime = const Duration(minutes: 25); // Rough estimate
    
    return JourneyRoute(
      stations: [from, interchangeStation, to],
      instructions: [
        'Board ${_getLineForStation(from.id)} at ${from.name}',
        'Travel to ${interchangeStation.name}',
        'Change to ${_getLineForStation(to.id)}',
        'Travel to ${to.name}'
      ],
      totalStations: 8, // Rough estimate
      estimatedTime: estimatedTime,
    );
  }

  String _getLineForStation(String stationId) {
    try {
      final station = MetroData.stations.firstWhere((s) => s.id == stationId);
      final line = MetroData.lines.firstWhere((l) => station.lines.contains(l.id));
      return line.name;
    } catch (e) {
      return 'Metro Line'; // Fallback if station not found
    }
  }
}