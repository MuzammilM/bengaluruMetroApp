import 'package:flutter/material.dart';
import '../models/metro_station.dart';
import '../data/metro_data.dart';
import '../services/route_service.dart';

class MetroProvider extends ChangeNotifier {
  final RouteService _routeService = RouteService();
  
  MetroStation? _fromStation;
  MetroStation? _toStation;
  JourneyRoute? _currentRoute;
  bool _isLoading = false;

  MetroStation? get fromStation => _fromStation;
  MetroStation? get toStation => _toStation;
  JourneyRoute? get currentRoute => _currentRoute;
  bool get isLoading => _isLoading;

  List<MetroStation> get allStations => MetroData.stations;
  List<MetroLine> get operationalLines => MetroData.lines.where((line) => line.isOperational).toList();

  void setFromStation(MetroStation? station) {
    _fromStation = station;
    _clearRoute();
    notifyListeners();
  }

  void setToStation(MetroStation? station) {
    _toStation = station;
    _clearRoute();
    notifyListeners();
  }

  void swapStations() {
    final temp = _fromStation;
    _fromStation = _toStation;
    _toStation = temp;
    _clearRoute();
    notifyListeners();
  }

  Future<void> findRoute() async {
    if (_fromStation == null || _toStation == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _currentRoute = await _routeService.findRoute(_fromStation!, _toStation!);
    } catch (e) {
      _currentRoute = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _clearRoute() {
    _currentRoute = null;
  }
}