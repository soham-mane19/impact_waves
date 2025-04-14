import 'package:flutter/material.dart';
import 'package:impact_waves/confirm_donationScreen.dart';
import 'package:impact_waves/deliverUpdatesScreen.dart';
import 'package:impact_waves/donation_cartScreen.dart';
import 'package:impact_waves/impactGallryScreen.dart';
import 'package:impact_waves/ngo_listing.dart';
import 'package:impact_waves/select_region.dart';

void main() {
  runApp(const DonationApp());
}

class DonationApp extends StatelessWidget {
  const DonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      initialRoute: '/select-region',
      routes: {
        '/select-region': (context) => const SelectRegionScreen(),
        '/ngo-listing': (context) => const NgoListingScreen(),
        '/donation-cart': (context) => const DonationCartScreen(),
        '/confirm-donation': (context) => const ConfirmDonationScreen(),
        '/delivery-updates': (context) => const DeliveryUpdatesScreen(),
        '/impact-gallery': (context) => const ImpactGalleryScreen(),
      },
    );
  }
}