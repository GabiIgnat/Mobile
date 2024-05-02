/*
This page will have a text field to enter the message to be sent,
a text where the converted message will be displayed(in a scrollable text field),
a input field to enter the phone number to which the message is to be sent,
a button to send the message.
 */

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';

import 'package:morse_code_flash/state_managers/phone_number_manager.dart';
import 'package:morse_code_flash/morse_converter.dart';

class SendSmsPage extends StatefulWidget {
  const SendSmsPage({super.key});

  @override
  SendSmsPageState createState() => SendSmsPageState();
}

class SendSmsPageState extends State<SendSmsPage> {
  String _message = '';
  String _morseCode = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final phoneNumberManager = Provider.of<PhoneNumberManager>(context, listen: false);
    _controller = TextEditingController(text: phoneNumberManager.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send SMS'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Consumer<PhoneNumberManager>(
          builder: (context, phoneNumberManager, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // input text field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _message = text;
                        _morseCode = MorseConverter.encodeString(_message);
                      });
                    },
                  ),
                ),

                // display converted message
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _morseCode,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        // copy to clipboard button
                        IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            FlutterClipboard.copy(_morseCode);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text copied to clipboard'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // input phone number field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Enter phone number',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {
                        // set the phone number to the provider
                        final phoneNumberManager = Provider.of<PhoneNumberManager>(context, listen: false);
                        phoneNumberManager.setPhoneNumber(text);
                      });
                    },
                  ),
                ),

                // send sms button
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // send sms
                      _sendSms(_morseCode, [phoneNumberManager.phoneNumber]);
                    },
                    child: const Text('Send SMS'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // send sms
  Future<void> _sendSms(String message, List<String> recipients) async {
    await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
          // error handling -> pop up a dialog box
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(onError.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );

          return '';
        });
  }
}