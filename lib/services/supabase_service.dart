import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseClient? _client;
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Supabase credentials not found in .env file');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    _client = Supabase.instance.client;
  }

  // Authentication methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Metro data methods
  static Future<List<Map<String, dynamic>>> getMetroStations() async {
    final response = await client
        .from('metro_stations')
        .select('*')
        .order('name');
    return response;
  }

  static Future<List<Map<String, dynamic>>> getMetroLines() async {
    final response = await client
        .from('metro_lines')
        .select('*')
        .order('name');
    return response;
  }

  static Future<void> saveUserJourney({
    required String fromStationId,
    required String toStationId,
    required Map<String, dynamic> routeData,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await client.from('user_journeys').insert({
      'user_id': user.id,
      'from_station_id': fromStationId,
      'to_station_id': toStationId,
      'route_data': routeData,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getUserJourneys() async {
    final user = currentUser;
    if (user == null) return [];

    final response = await client
        .from('user_journeys')
        .select('*, from_station:metro_stations!from_station_id(*), to_station:metro_stations!to_station_id(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(10);
    
    return response;
  }
}