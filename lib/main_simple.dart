import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleMetroApp());
}

class SimpleMetroApp extends StatelessWidget {
  const SimpleMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bangalore Metro - Simple Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SimpleHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bangalore Metro Journey Planner'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.train,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Bangalore Metro Journey Planner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'App is loading successfully!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}