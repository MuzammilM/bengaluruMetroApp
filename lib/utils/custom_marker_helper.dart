import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/metro_station.dart';
import '../data/metro_data.dart';

class CustomMarkerHelper {
  // Cache for storing created markers
  static final Map<String, BitmapDescriptor> _markerCache = {};
  
  // Pre-created standard markers
  static BitmapDescriptor? _greenMarker;
  static BitmapDescriptor? _purpleMarker;
  static BitmapDescriptor? _yellowMarker;
  static BitmapDescriptor? _orangeMarker;
  static BitmapDescriptor? _redMarker;
  static BitmapDescriptor? _blueMarker;
  
  // Initialize standard markers
  static Future<void> initializeStandardMarkers() async {
    if (_greenMarker != null) return; // Already initialized
    
    _greenMarker = await _createSimpleMarker(Colors.green, 'G');
    _purpleMarker = await _createSimpleMarker(Colors.purple, 'P');
    _yellowMarker = await _createSimpleMarker(Colors.yellow[700]!, 'Y');
    _orangeMarker = await _createSimpleMarker(Colors.orange, 'INT');
    _redMarker = await _createSimpleMarker(Colors.red, 'FROM');
    _blueMarker = await _createSimpleMarker(Colors.blue, 'TO');
  }
  
  static Future<BitmapDescriptor> _createSimpleMarker(Color color, String text) async {
    return createCustomMarker(
      text: text,
      backgroundColor: color,
      textColor: Colors.white,
      size: 40,
      isSelected: false,
    );
  }
  
  static Future<BitmapDescriptor> createCustomMarker({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    double size = 100,
    bool isSelected = false,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    final double radius = size / 2;
    final Offset center = Offset(radius, radius);
    
    // Draw outer ring if selected
    if (isSelected) {
      final Paint outerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, outerPaint);
      
      final Paint ringPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawCircle(center, radius - 3, ringPaint);
    }
    
    // Draw main circle
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, isSelected ? radius - 8 : radius - 4, paint);
    
    // Draw border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, isSelected ? radius - 8 : radius - 4, borderPaint);
    
    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: isSelected ? 14 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
    
    // Convert to image
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    
    return BitmapDescriptor.bytes(uint8List);
  }

  static Future<BitmapDescriptor> createStationMarker(
    MetroStation station, {
    bool isFromStation = false,
    bool isToStation = false,
  }) async {
    // Ensure standard markers are initialized
    await initializeStandardMarkers();
    
    // Use pre-created markers for better performance
    if (isFromStation) {
      return _redMarker!;
    } else if (isToStation) {
      return _blueMarker!;
    } else if (station.isInterchange) {
      // For interchange stations, check cache first
      final cacheKey = 'interchange_${station.lines.join('_')}';
      if (_markerCache.containsKey(cacheKey)) {
        return _markerCache[cacheKey]!;
      }
      
      // Create custom interchange marker
      final lineInitials = station.lines.map((lineId) {
        switch (lineId) {
          case 'green': return 'G';
          case 'purple': return 'P';
          case 'yellow': return 'Y';
          default: return 'M';
        }
      }).join('');
      
      final marker = await createCustomMarker(
        text: lineInitials,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        size: 40,
        isSelected: false,
      );
      
      _markerCache[cacheKey] = marker;
      return marker;
    } else {
      // Single line station - use pre-created markers
      final primaryLine = station.lines.first;
      switch (primaryLine) {
        case 'green':
          return _greenMarker!;
        case 'purple':
          return _purpleMarker!;
        case 'yellow':
          return _yellowMarker!;
        default:
          return _greenMarker!; // Fallback
      }
    }
  }
  
  // Clear cache when needed
  static void clearCache() {
    _markerCache.clear();
  }
}