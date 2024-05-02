/*
This page will display a short description of the app and the developer.
Then will display general information about Morse Code, how it works, its history
and the Morse Code table.
 */
import 'package:flutter/material.dart';

import 'package:morse_code_flash/morse_converter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About the App:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text(
              'This app allows users to convert text to Morse code and vice versa. '
                  'It also provides functionality to flash Morse code using the device\'s flashlight, '
                  'to send Morse code messages via SMS and to decrypt received Morse code messages.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            const Text(
              'Morse Code:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text(
              'Morse code is a method used in telecommunication to encode text characters '
                  'as sequences of two different signal durations, called dits and dahs.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),
            const Text(
              'It was devised by Samuel Morse and Alfred Vail in the early 1830s. '
                  'The Morse code table assigns a series of dots and dashes to each letter of the alphabet, '
                  'as well as numbers and punctuation marks.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),
            const Text(
              'The duration of a dit is the basic unit of time measurement in Morse code, '
                  'while a dah is three times the duration of a dit. '
                  'The space between letters is equal to three dits, '
                  'while the space between words is equal to seven dits.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),
            const Text(
              'It was mostly used to communicate in times of war, '
                  'but it is still used today in various applications, '
                  'such as aviation, maritime, and amateur radio.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
            const Text(
              'Morse Code Table:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Display the Morse code table in a table format
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(), // Add border around the table
              children: [
                // Define the header row with the column titles
                const TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Letter',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 18), // Customize font weight and size
                          ),
                        )
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Morse Code',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 18), // Customize font weight and size
                          ),
                        )
                      ),
                    ),
                  ],
                ),

                // Generate table rows dynamically based on the Morse code table
                for (var entry in MorseConverter.morseCodeMap.entries)
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "'${entry.key}'",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Customize font weight and size
                            ), // Display the letter
                          )
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20), // Customize font weight and size
                            ), // Display the Morse code
                          )
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
