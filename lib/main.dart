import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:e_store/screens/gallery.dart';

// Color scheme for Theme
final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
  seedColor: const Color.fromARGB(255, 255, 255, 255),
);
// Theme definition
final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
  ),
);

class MyHttpOverrides extends HttpOverrides {
     @override
     HttpClient createHttpClient(SecurityContext? context) {
       return super.createHttpClient(context)
         ..badCertificateCallback =
             (X509Certificate cert, String host, int port) => true;
     }
   }


void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  final categories = await fetchFromRegulusVercel('productlines');
  final products = await fetchFromRegulusVercel('products');
  */
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    ProviderScope(
      child: RegulusStore()
    )
  );
}

class RegulusStore extends ConsumerWidget {
  const RegulusStore({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set categories in Provider
      //final settingsNotifier = ref.read(settingsProvider.notifier);
      //settingsNotifier.setSettings(Settings(token: token));
      // Set products in Provider
      //final walletsNotifier = ref.read(walletsProvider.notifier);
      //walletsNotifier.setWallets(Wallets(wallets: wallets));
    });
    
    return MaterialApp(
      title: 'Regulus Store',
      theme: theme,
      home: GalleryScreen(),
    );
  }
}

