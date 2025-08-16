import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/metro_provider.dart';
import 'providers/auth_provider.dart';
import 'services/supabase_service.dart';

// Simple offline auth provider for when Supabase is not available
class OfflineAuthProvider extends ChangeNotifier {
  bool get isAuthenticated => true; // Always authenticated in offline mode
  bool get isLoading => false;
  String? get errorMessage => null;
  dynamic get user => {'email': 'offline@user.com'};

  Future<void> signOut() async {
    // No-op in offline mode
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool supabaseInitialized = false;
  try {
    await SupabaseService.initialize();
    supabaseInitialized = true;
    print('Supabase initialized successfully');
  } catch (e) {
    print('Supabase initialization failed: $e');
    print('App will run in offline mode');
  }

  runApp(BangaloreMetroApp(supabaseEnabled: supabaseInitialized));
}

class BangaloreMetroApp extends StatelessWidget {
  final bool supabaseEnabled;

  const BangaloreMetroApp({super.key, required this.supabaseEnabled});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (supabaseEnabled)
          ChangeNotifierProvider(create: (context) => AuthProvider())
        else
          ChangeNotifierProvider(create: (context) => OfflineAuthProvider()),
        ChangeNotifierProvider(create: (context) => MetroProvider()),
      ],
      child: MaterialApp(
        title: 'Bangalore Metro Journey Planner',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: supabaseEnabled
            ? Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.isAuthenticated) {
                    return const HomeScreen();
                  } else {
                    return const AuthScreen();
                  }
                },
              )
            : const HomeScreen(), // Skip auth if Supabase is not available
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
