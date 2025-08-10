import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/metro_station.dart';
import '../providers/metro_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<MetroProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MetroStation>(
                  value: selectedStation,
                  hint: Text('Select $label station'),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: provider.allStations.map((station) {
                    return DropdownMenuItem<MetroStation>(
                      value: station,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              station.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (station.isInterchange)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'INT',
                                style: TextStyle(
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