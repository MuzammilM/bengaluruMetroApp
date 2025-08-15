import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metro_provider.dart';
import '../widgets/station_selector.dart';
import '../widgets/route_display.dart';
import '../widgets/metro_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bangalore Metro Journey Planner'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MetroProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              // Left panel - Journey planner
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: const Border(
                      right: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Plan Your Journey',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // From Station
                      StationSelector(
                        label: 'From',
                        selectedStation: provider.fromStation,
                        onStationSelected: provider.setFromStation,
                        icon: Icons.radio_button_checked,
                        iconColor: Colors.green,
                      ),

                      const SizedBox(height: 16),

                      // Swap button
                      Center(
                        child: IconButton(
                          onPressed: provider.swapStations,
                          icon: const Icon(Icons.swap_vert),
                          iconSize: 32,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // To Station
                      StationSelector(
                        label: 'To',
                        selectedStation: provider.toStation,
                        onStationSelected: provider.setToStation,
                        icon: Icons.location_on,
                        iconColor: Colors.red,
                      ),

                      const SizedBox(height: 24),

                      // Find Route button
                      ElevatedButton(
                        onPressed: provider.fromStation != null &&
                                provider.toStation != null &&
                                !provider.isLoading
                            ? provider.findRoute
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Find Route',
                                style: TextStyle(fontSize: 16)),
                      ),

                      const SizedBox(height: 12),
                      
                      // Clear Selection button
                      if (provider.fromStation != null || provider.toStation != null)
                        OutlinedButton(
                          onPressed: () {
                            provider.setFromStation(null);
                            provider.setToStation(null);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Clear Selection', style: TextStyle(fontSize: 16)),
                        ),

                      const SizedBox(height: 24),

                      // Route display
                      if (provider.currentRoute != null)
                        Expanded(
                          child: RouteDisplay(route: provider.currentRoute!),
                        ),
                    ],
                  ),
                ),
              ),

              // Right panel - Map
              Expanded(
                flex: 2,
                child: const MetroMap(),
              ),
            ],
          );
        },
      ),
    );
  }
}
