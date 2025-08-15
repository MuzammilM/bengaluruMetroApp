import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/metro_provider.dart';

void main() {
  runApp(const BangaloreMetroApp());
}

class BangaloreMetroApp extends StatelessWidget {
  const BangaloreMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MetroProvider(),
      child: MaterialApp(
        title: 'Bangalore Metro Journey Planner',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
