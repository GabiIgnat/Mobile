/*
MorseCode - This app should take a phrase and at the touch of a button should make
the led on the phone flash the morse code for that phrase. It should also display the
code for a certain character when the led is flashing it. The app should also be able to
send that code via sms. Also, the app should be able to decrypt the received sms.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torch_light/torch_light.dart';
import 'dart:async';

import 'package:morse_code_flash/state_managers/dit_duration_manager.dart';
import 'package:morse_code_flash/morse_converter.dart';


class TorchMorseCode extends StatefulWidget {
  const TorchMorseCode({super.key});

  @override
  TorchMorseCodeState createState() {
    return TorchMorseCodeState();
  }
}

class TorchMorseCodeState extends State<TorchMorseCode> {
  late final int _ditDurationMs;

  String title = 'Flash the Morse Code';
  String _inputText = "";
  String _morseCode = '';

  String _currentCharacter = '';
  int _indexCurrentCharacter = 0;
  int _indexMorseCharacter = 0;

  bool _showInputField = true;
  bool _isRunning = false;

  Completer<void> _completer = Completer<void>();

  @override
  void initState() {
    super.initState();

    _ditDurationMs = Provider.of<DitDurationManager>(context, listen: false).ditDurationMs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // input text field
            if (_showInputField)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter text',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _inputText = text;
                    });
                  },
                ),
              )
            else
              // if we are flashing the morse code, we show the input with the current character highlighted
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                      text: TextSpan(
                        children: [
                          for (int i = 0; i < _inputText.length; i++)
                            TextSpan(
                              text: _inputText[i],
                              style: TextStyle(
                                fontWeight: i == _indexCurrentCharacter ? FontWeight.bold : FontWeight.normal,
                                color: i == _indexCurrentCharacter ? Colors.red : Colors.black,
                                fontSize: 30,
                              ),
                            ),
                        ],
                      ),
                    ),
              ),

            // translation of the current character
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Current character
                  Text(
                    _currentCharacter,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  // Translation of the current character
                  RichText(
                    text: TextSpan(
                      children: [
                        for (int i = 0; i < _morseCode.length; i++)
                          TextSpan(
                            text: _morseCode[i],
                            style: TextStyle(
                              fontWeight: i == _indexMorseCharacter ? FontWeight.bold : FontWeight.normal,
                              color: i == _indexMorseCharacter ? Colors.red : Colors.black,
                              fontSize: 30,
                            ),
                          ),
                      ]
                    ),
                  ),
                ],
              ),
            ),

            // start/stop button
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isRunning = !_isRunning;
                });

                if (_isRunning) {
                  await _flashMorseCode(_inputText);
                } else {
                  // stop the flashing
                  _stopForceFlash();
                }
                },
              child: Text(_isRunning ? 'Stop' : 'Start'),
            )
          ]
        ),
      ),
    );
  }

  Future<void> _flashMorseCode(String text) async {
    _completer = Completer<void>();

    for (int i = 0; i < text.length && _isRunning == true; i++) {
      setState(() {
        _currentCharacter = text[i];
        _indexCurrentCharacter = i;
        _morseCode = MorseConverter.encodeLetter(text[i]);
        _showInputField = false;
      });

      for (int j = 0; j < _morseCode.length && _isRunning == true; j++) {
        setState(() {
          _indexMorseCharacter = j;
        });

        await _flashMorseCharacter(_morseCode[j]);
      }

      // letter separator
      setState(() {
        _morseCode = ' ';
        _indexMorseCharacter = 0;
      });

      await _flashMorseCharacter(' ');
    }

    // reset the character and translation
    setState(() {
      _currentCharacter = '';
      _morseCode = '';
      _indexMorseCharacter = 0;
      _indexCurrentCharacter = 0;
      _showInputField = true;
      _isRunning = false;
    });

    _completer.complete();
  }

  void _stopForceFlash() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  Future<void> _flashMorseCharacter(String ch) async {
    if (!_isRunning) return;

    if (ch == '/') {  // word separator
      await TorchLight.disableTorch();
      await Future.delayed(Duration(milliseconds: 7 * _ditDurationMs));
      return;
    } else if (ch == ' ') {  // letter separator
      await TorchLight.disableTorch();
      await Future.delayed(Duration(milliseconds: 3 * _ditDurationMs));
      return;
    } else if (ch == '.') {
      await TorchLight.enableTorch();
      await Future.delayed(Duration(milliseconds: _ditDurationMs));
      await TorchLight.disableTorch();
      await Future.delayed(Duration(milliseconds: _ditDurationMs));
      return;
    } else if (ch == '-') {
      await TorchLight.enableTorch();
      await Future.delayed(Duration(milliseconds: 3 * _ditDurationMs));
      await TorchLight.disableTorch();
      await Future.delayed(Duration(milliseconds: _ditDurationMs));
      return;
    }
  }
}