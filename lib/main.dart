import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/const.dart';
import 'package:food_app/services/notification_services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:food_app/splash_screen.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 143, 0),
);

final theme = ThemeData().copyWith(
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  ),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await dotenv.load(fileName: ".env");


  assert(dotenv.env['STRIPE_PUBLISHABLE_KEY'] != null, 
         'Stripe publishable key missing from .env');
  assert(dotenv.env['STRIPE_SECRET_KEY'] != null,
         'Stripe secret key missing from .env');

 
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;


  await Firebase.initializeApp();
  await NotificationServices().initFCM();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

print('Loaded ENV:');
dotenv.env.forEach((key, value) => print('$key = ${value?.substring(0, 8)}...'));
  print('Stripe Keys Loaded:');
  print('Publishable: ${dotenv.env['STRIPE_PUBLISHABLE_KEY']?.substring(0, 8)}...');
  print('Secret: ${dotenv.env['STRIPE_SECRET_KEY']?.substring(0, 8)}...');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
    );
  }
}
