
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:morse_code_flash/state_managers/dit_duration_manager.dart';
import 'package:morse_code_flash/pages/send_sms_page.dart';
import 'package:morse_code_flash/pages/settings_page.dart';
import 'package:morse_code_flash/pages/translate_morse_page.dart';

import 'package:morse_code_flash/pages/morse_code_page.dart';
import 'package:morse_code_flash/pages/about_page.dart';
import 'package:morse_code_flash/state_managers/phone_number_manager.dart';

import 'package:morse_code_flash/homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PhoneNumberManager()),
        ChangeNotifierProvider(create: (context) => DitDurationManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        "/home": (context) => const HomePage(),
        "/flash_morse": (context) => const TorchMorseCode(),
        "/send_sms": (context) => const SendSmsPage(),
        "/translate_morse": (context) => const ReadAndTranslatePage(),
        "/settings": (context) => const SettingsPage(),
        "/about": (context) => const AboutPage(),
      },
    );
  }
}