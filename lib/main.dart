import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/metro_provider.dart';
import 'providers/auth_provider.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await SupabaseService.initialize();
  } catch (e) {
    print('Supabase initialization failed: $e');
  }
  
  runApp(const BangaloreMetroApp());
}

class BangaloreMetroApp extends StatelessWidget {
  const BangaloreMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MetroProvider()),
      ],
      child: MaterialApp(
        title: 'Bangalore Metro Journey Planner',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isAuthenticated) {
              return const HomeScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
