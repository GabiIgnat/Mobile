/*
This page allows to modify the dit duration of the Morse code.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:morse_code_flash/state_managers/dit_duration_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late int _ditDurationMs;

  @override
  void initState() {
    super.initState();

    _ditDurationMs = Provider.of<DitDurationManager>(context, listen: false).ditDurationMs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Adjust Dit Duration (ms): $_ditDurationMs'),
            Slider(
              value: _ditDurationMs.toDouble(),
              min: 100,
              max: 1000,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _ditDurationMs = value.toInt();

                  final ditDurationManager = Provider.of<DitDurationManager>(context, listen: false);
                  ditDurationManager.setDitDurationMs(_ditDurationMs);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
