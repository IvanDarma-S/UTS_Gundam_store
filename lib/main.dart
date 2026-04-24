import 'package:apps_marketplace_integration_backend/core/routes/app_router.dart';
import 'package:apps_marketplace_integration_backend/core/services/secure_storage.dart';
import 'package:apps_marketplace_integration_backend/core/theme/app_theme.dart';
import 'package:apps_marketplace_integration_backend/core/providers/theme_provider.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/providers/auth_provider.dart';
import 'package:apps_marketplace_integration_backend/features/dashboard/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // 1. Bungkus MyApp dengan MultiProvider di level paling atas
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ), // Letakkan di sini
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider(), lazy: true),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Sekarang context.watch akan bekerja karena Provider ada di atasnya
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Gundam Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // 3. Gunakan instance themeProvider, bukan class ThemeProvider secara static
      themeMode: themeProvider.themeMode,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}

// SplashPage: cek token tersimpan, redirect otomatis
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await SecureStorageService.getToken();
      if (!mounted) return;

      // Redirect berdasarkan token
      final route = token != null ? AppRouter.dashboard : AppRouter.login;
      Navigator.pushReplacementNamed(context, route);
    } catch (e) {
      // Jika error, redirect ke login
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google_logo.png', width: 80, height: 80),
            const SizedBox(height: 20),
            const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
