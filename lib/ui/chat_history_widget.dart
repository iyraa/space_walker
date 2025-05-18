import 'package:flutter/material.dart';

// Define the ChatMessage class to hold each message's data.
class ChatMessage {
  final String character;
  final String narrative;
  final String? choice;

  ChatMessage({required this.character, required this.narrative, this.choice});
}

class ChatHistoryWidget extends StatelessWidget {
  final List<ChatMessage> chatHistory;

  const ChatHistoryWidget({super.key, required this.chatHistory});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: ListView.builder(
        reverse: true, // Show the latest message at the top
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          final message = chatHistory[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character's image (optional)
                const SizedBox(width: 8),
                // The character's name and narrative
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.character,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: colorScheme.primary,
                        ),
                      ),
                      // TypewriterText(
                      //   text: message.character,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 11,
                      //     color: colorScheme.primary,
                      //   ),
                      // ),
                      const SizedBox(height: 2),
                      Text(
                        message.narrative,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.primary,
                        ),
                      ),

                      // Display the choice if available
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
