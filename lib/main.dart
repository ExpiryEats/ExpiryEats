import 'package:expiry_eats/colors.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Supabase.initialize(
    url: 'https://athgjcivewemcianadwm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aGdqY2l2ZXdlbWNpYW5hZHdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzMDk5NDEsImV4cCI6MjA1Nzg4NTk0MX0.TzDSP3Mc944O-e8yMh_Gtrt6nh2LVC7xI29ZQouDx5A',
  );

  final cacheProvider = CacheProvider();
  cacheProvider.fetchReferenceData();

 runApp(
  ChangeNotifierProvider.value(
    value: cacheProvider,
    child: MaterialApp(
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary40, // or your custom green
          surface: AppTheme.surface, // fixes the purple tint
        ),
        scaffoldBackgroundColor: AppTheme.surface,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary80),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary80),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primary80, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: TextStyle(color: AppTheme.primary80),
        ),
      ),
    ),
  ),
);
}