import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metro_provider.dart';

class MetroMapSimple extends StatelessWidget {
  const MetroMapSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetroProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[100],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'Metro Map',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Google Maps will be loaded here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}