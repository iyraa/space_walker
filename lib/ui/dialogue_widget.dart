// dialogue_widget.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:space_walker/services/flag_service.dart';

class DialogueWidget extends StatelessWidget {
  final String character;
  final String narrative;
  final String characterImg;
  final bool isLastLine;
  final List<dynamic> availableChoices;
  final void Function(String) goToNode;

  const DialogueWidget({
    super.key,
    required this.character,
    required this.narrative,
    required this.isLastLine,
    required this.characterImg,
    required this.availableChoices,
    required this.goToNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$character:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            narrative,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),

          if (!isLastLine)
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(Icons.rocket_launch_outlined),
            ),
        ],
      ),
    );
    // );
  }
}
