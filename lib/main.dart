import 'package:expiry_eats/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://athgjcivewemcianadwm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0aGdqY2l2ZXdlbWNpYW5hZHdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIzMDk5NDEsImV4cCI6MjA1Nzg4NTk0MX0.TzDSP3Mc944O-e8yMh_Gtrt6nh2LVC7xI29ZQouDx5A',
  );

  final cacheProvider = CacheProvider();
  cacheProvider.fetchReferenceData();

  runApp(
    ChangeNotifierProvider.value(
      value: cacheProvider,
      child: const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
