import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:provider/provider.dart';

import 'package:morse_code_flash/state_managers/phone_number_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: const Text("Home Page"),
        backgroundColor: Colors.orangeAccent,
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.pink,
                  image: DecorationImage(
                      image: NetworkImage("https://pbs.twimg.com/media/DK-wne5VAAEOIo9?format=jpg&name=small"),
                      fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 4.0,
                    child: Text(
                      "Communicate in Morse Code",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),

            ListTile(
              onTap: () {
                // turn off torch
                _turnOffTorch();
                  Navigator.popAndPushNamed(context, "/flash_morse");
                },
              leading: const ImageIcon(
                  AssetImage("assets/images/morse-code.png"),
                  color: Colors.orangeAccent),
              title: const Text("Flash the Morse Code"),
            ),

            ListTile(
                onTap: () {
                  _resetPhoneNumber();
                  // turn off torch
                  _turnOffTorch();
                  Navigator.popAndPushNamed(context, "/send_sms");
                },
                leading: const Icon(Icons.sms_rounded, color: Colors.orangeAccent),
                title: const Text("Send Encrypted Message"),
            ),

            ListTile(
                onTap: () {
                  _resetPhoneNumber();
                  // turn off torch
                  _turnOffTorch();
                  Navigator.popAndPushNamed(context, "/translate_morse");
                },
                leading: const Icon(Icons.translate_rounded, color: Colors.orangeAccent),
                title: const Text("Translate Received Message"),
            ),

            const Divider(),
            ListTile(
              onTap: () {
                _resetPhoneNumber();
                // turn off torch
                _turnOffTorch();
                Navigator.popAndPushNamed(context, "/settings");
              },
              leading: const Icon(Icons.settings, color: Colors.orangeAccent),
              title: const Text("Settings"),
            ),

            const Divider(),
            ListTile(
                onTap: () {
                  _resetPhoneNumber();
                  // turn off torch
                  _turnOffTorch();
                  Navigator.popAndPushNamed(context, "/about");
                },
                leading: const Icon(Icons.help_center_rounded, color: Colors.orangeAccent),
                title: const Text("About"),
              ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // torch symbol
            IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                size: 200,
                color: _isTorchOn ? Colors.yellowAccent : Colors.grey,
              ),
              onPressed: () async {
                await _toggleTorch();
              },
            ),
          ],
        )
      ),
    );
  }

  Future<void> _toggleTorch() async {
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
    if (_isTorchOn) {
      await TorchLight.enableTorch();
    } else {
      await TorchLight.disableTorch();
    }
  }

  Future<void> _turnOffTorch() async {
    setState(() {
      _isTorchOn = false;
    });
    await TorchLight.disableTorch();
  }

  void _resetPhoneNumber() {
    final phoneNumberManager = Provider.of<PhoneNumberManager>(context, listen: false);
    phoneNumberManager.setPhoneNumber('');
  }
}