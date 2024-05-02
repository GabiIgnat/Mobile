/*
This page will open up all the sms messages and will choose one to decrypt.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:morse_code_flash/state_managers/phone_number_manager.dart';
import 'package:morse_code_flash/morse_converter.dart';
import 'package:morse_code_flash/pages/message_listing_page.dart';


class ReadAndTranslatePage extends StatefulWidget {
  const ReadAndTranslatePage({super.key});

  @override
  ReadAndTranslatePageState createState() => ReadAndTranslatePageState();
}

class ReadAndTranslatePageState extends State<ReadAndTranslatePage> {
  String _selectedMessage = '';
  String _translatedMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read and Translate'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Consumer<PhoneNumberManager>(
        builder: (context, phoneNumberManager, _) {
          return Column(
            children: [
                Center(
                // button for displaying the sms messages
                child: ElevatedButton(
                  onPressed: () async {
                    final receivedArgs = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageListingPage(),
                      ),
                    );

                    if (receivedArgs != null) {
                      setState(() {
                        _selectedMessage = receivedArgs[0] as String;
                        _translatedMessage = MorseConverter.decodeMorseString(_selectedMessage);
                        String phoneNumber = receivedArgs[1] as String;

                        // set the phone number to the provider
                        final phoneNumberManager = Provider.of<PhoneNumberManager>(context, listen: false);
                        phoneNumberManager.setPhoneNumber(phoneNumber);
                      });
                    }
                  },
                  child: const Text('Read SMS'),
                ),
              ),

              if (_selectedMessage.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Add some spacing between widgets

                    // Table to display information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1), // Adjust column width
                          1: FlexColumnWidth(2), // Adjust column width
                        },
                        children: [
                          _buildTableRow('Phone number:', phoneNumberManager.phoneNumber),
                          _buildTableRow('Morse Code:', _selectedMessage),
                          _buildTableRow('Translated:', _translatedMessage),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20), // Add some spacing between widgets

                    // Reply button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/send_sms');
                        },
                        child: const Text('Reply'),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 18,
                  color:
                    label == 'Phone number:' ? Colors.blueAccent :
                    label == 'Morse Code:' ? Colors.redAccent :
                    Colors.lightGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


