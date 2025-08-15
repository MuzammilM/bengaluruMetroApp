import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/metro_station.dart';
import '../providers/metro_provider.dart';
import '../data/metro_data.dart';

class StationSelector extends StatelessWidget {
  final String label;
  final MetroStation? selectedStation;
  final Function(MetroStation?) onStationSelected;
  final IconData icon;
  final Color iconColor;

  const StationSelector({
    super.key,
    required this.label,
    required this.selectedStation,
    required this.onStationSelected,
    required this.icon,
    required this.iconColor,
  });

  Color _getStationLineColor(MetroStation? station) {
    if (station == null) return Colors.grey;
    
    if (station.isInterchange) {
      return Colors.orange;
    }
    
    final primaryLine = station.lines.first;
    final line = MetroData.lines.firstWhere((l) => l.id == primaryLine);
    return line.color;
  }

  String _getLineInitials(MetroStation station) {
    if (station.isInterchange) {
      return station.lines.map((lineId) {
        switch (lineId) {
          case 'green': return 'G';
          case 'purple': return 'P';
          case 'yellow': return 'Y';
          default: return 'M';
        }
      }).join('');
    } else {
      final primaryLine = station.lines.first;
      switch (primaryLine) {
        case 'green': return 'G';
        case 'purple': return 'P';
        case 'yellow': return 'Y';
        default: return 'M';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MetroProvider>(
      builder: (context, provider, child) {
        final borderColor = _getStationLineColor(selectedStation);
        final hasSelection = selectedStation != null;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: hasSelection ? borderColor : iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: hasSelection ? borderColor : null,
                  ),
                ),
                if (hasSelection) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _getLineInitials(selectedStation!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                  width: hasSelection ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: hasSelection ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MetroStation>(
                  value: selectedStation,
                  hint: Text('Select $label station'),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: provider.allStations.map((station) {
                    final stationLineColor = _getStationLineColor(station);
                    return DropdownMenuItem<MetroStation>(
                      value: station,
                      child: Row(
                        children: [
                          // Line indicator
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: stationLineColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              station.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: stationLineColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getLineInitials(station),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: onStationSelected,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}