import 'package:ewaste_manager/screens/auth/login_screen.dart';
import 'package:ewaste_manager/screens/home_screen.dart';
import 'package:ewaste_manager/services/firebase_auth_service.dart';
import 'package:ewaste_manager/services/firebase_storage_service.dart';
import 'package:ewaste_manager/services/firestore_service.dart';
import 'package:ewaste_manager/theme/theme_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized successfully!");
  } catch (e) {
    debugPrint("❌ Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<FirebaseStorageService>(create: (_) => FirebaseStorageService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'E-Waste Manager',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

/// Call this function to logout from the app
Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    debugPrint("✅ User signed out successfully.");
  } catch (e) {
    debugPrint("❌ Logout error: $e");
  }
}
