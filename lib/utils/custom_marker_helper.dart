import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/metro_station.dart';
import '../data/metro_data.dart';

class CustomMarkerHelper {
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
    double size = 40,
  }) async {
    Color backgroundColor;
    String text;
    bool isSelected = isFromStation || isToStation;
    
    if (isFromStation) {
      backgroundColor = Colors.red;
      text = 'FROM';
    } else if (isToStation) {
      backgroundColor = Colors.blue;
      text = 'TO';
    } else if (station.isInterchange) {
      backgroundColor = Colors.orange;
      // Show all line initials for interchange
      final lineInitials = station.lines.map((lineId) {
        switch (lineId) {
          case 'green': return 'G';
          case 'purple': return 'P';
          case 'yellow': return 'Y';
          default: return 'M';
        }
      }).join('');
      text = lineInitials;
    } else {
      // Single line station
      final primaryLine = station.lines.first;
      final line = MetroData.lines.firstWhere((l) => l.id == primaryLine);
      backgroundColor = line.color;
      
      switch (primaryLine) {
        case 'green':
          text = 'G';
          break;
        case 'purple':
          text = 'P';
          break;
        case 'yellow':
          text = 'Y';
          break;
        default:
          text = 'M';
      }
    }
    
    return createCustomMarker(
      text: text,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      isSelected: isSelected,
      size: size,
    );
  }
}