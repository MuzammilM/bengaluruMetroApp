import 'package:flutter/material.dart';

class MetroStation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> lines;
  final bool isInterchange;

  const MetroStation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lines,
    this.isInterchange = false,
  });

  @override
  String toString() => name;
}

class MetroLine {
  final String id;
  final String name;
  final Color color;
  final List<String> stations;
  final bool isOperational;

  MetroLine({
    required this.id,
    required this.name,
    required this.color,
    required this.stations,
    this.isOperational = true,
  });
}

class JourneyRoute {
  final List<MetroStation> stations;
  final List<String> instructions;
  final int totalStations;
  final Duration estimatedTime;

  const JourneyRoute({
    required this.stations,
    required this.instructions,
    required this.totalStations,
    required this.estimatedTime,
  });
}