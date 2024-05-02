/*
This page will list all the messages and will allow the user to select one to decrypt.
*/

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';


class MessageListingPage extends StatelessWidget {
  final SmsQuery _query = SmsQuery();

  MessageListingPage({super.key});
  // request the READ_SMS permission

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Listing'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<SmsMessage>>(
        future: _requestPermissionAndQuerySms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final messages = snapshot.data;
            return ListView.builder(
              itemCount: messages?.length,
              itemBuilder: (context, index) {
                final message = messages?[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, [message?.body, message?.address]);
                  },
                  child: Card(
                    color: index % 2 == 0 ? Colors.orange[100] : Colors.orange[200],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message?.body ?? 'No body',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                message?.address ?? 'No address',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                message?.date.toString() ?? 'No date',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<SmsMessage>> _requestPermissionAndQuerySms() async {
    // Request the READ_SMS permission
    final status = await Permission.sms.request();

    // Check if permission is granted
    if (status.isGranted) {
      // Permission granted, query SMS messages
      List<SmsMessage> messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);
      // filter out messages with empty body or characters that are not Morse code
      return _filterMessages(messages);
    } else {
      // Permission denied, handle accordingly
      // For example, you can display a message to the user
      throw Exception('SMS permission is required to read messages.');
    }
  }

  Future<List<SmsMessage>> _filterMessages(List<SmsMessage> messages) {
    List<SmsMessage> filteredMessages = [];

    for (var message in messages) {
      if (message.body!.isEmpty) {
        continue;
      }

      // Check if the message contains any characters that are not Morse code (not dots, dashes, spaces or slashes)
      RegExp regex = RegExp(r'[^./ -]');

      if (regex.hasMatch(message.body!)) {
        continue;
      }

      filteredMessages.add(message);
    }

    return Future(() => filteredMessages);
  }
}
