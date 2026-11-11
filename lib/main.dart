import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'providers/task_provider.dart';
import 'providers/quote_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initializationError;

  // Periksa konfigurasi Supabase terlebih dahulu.
  if (!AppConfig.isSupabaseConfigured) {
    initializationError =
        'Konfigurasi Supabase belum ditemukan. '
        'Pastikan supabase_config.json tersedia '
        'dan dijalankan menggunakan dart-define-from-file.';
  } else {
    try {
      // Inisialisasi Supabase sebelum menjalankan aplikasi.
      await Supabase.initialize(
        url: AppConfig.supabaseUrl.trim(),
        publishableKey: AppConfig.supabasePublishableKey.trim(),
      );

      debugPrint('Supabase init completed');
    } catch (error, stackTrace) {
      initializationError = error.toString();

      debugPrint('Supabase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  runApp(RuangTuntasApp(initializationError: initializationError));
}

class RuangTuntasApp extends StatelessWidget {
  const RuangTuntasApp({super.key, this.initializationError});

  final String? initializationError;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => QuoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RuangTuntas',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5267A5)),
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        ),
        home: initializationError != null
            ? InitializationErrorPage(message: initializationError!)
            : const HomeScreen(),
      ),
    );
  }
}

class InitializationErrorPage extends StatelessWidget {
  const InitializationErrorPage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RuangTuntas'), centerTitle: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 72, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Koneksi Supabase Belum Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Aplikasi belum dapat mengakses database. '
                'Periksa konfigurasi Supabase.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
