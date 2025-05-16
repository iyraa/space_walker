// dialogue_widget.dart
import 'package:flutter/material.dart';

class DialogueWidget extends StatelessWidget {
  final String character;
  final String narrative;
  // final String characterImg;
  final bool isLastLine;
  // final List<dynamic> availableChoices;
  // final void Function(String) goToNode;

  const DialogueWidget({
    super.key,
    required this.character,
    required this.narrative,
    required this.isLastLine,
    // required this.characterImg,
    // required this.availableChoices,
    // required this.goToNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$character:',
                style: const TextStyle(
                  fontFamily: 'BrunoAceSC',
                  color: Color(0xFF9ED7D0),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                narrative,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),

              const SizedBox(height: 5.0),
            ],
          ),
          if (!isLastLine)
            Positioned(
              right: 20,
              bottom: 0,
              child: Icon(
                Icons.rocket_launch_outlined,
                color: Color(0xFF9ED7D0),
              ),
            ),
        ],
      ),
    );
  }
}
