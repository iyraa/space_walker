import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';

class DialogueWidget extends StatelessWidget {
  final DialogueLine dialogue;
  final VoidCallback onNext;
  final String playerName;
  final bool isLastLine;

  const DialogueWidget({
    super.key,
    required this.dialogue,
    required this.onNext,
    required this.playerName,
    required this.isLastLine,
  });

  @override
  Widget build(BuildContext context) {
    final character = dialogue.character.replaceAll('PLAYER', playerName);
    final narrative = dialogue.narrative.replaceAll('PLAYER', playerName);

    return GestureDetector(
      onTap: onNext,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
        //color: Colors.red.withOpacity(0.2), // for debugging
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$character:',
                  style: const TextStyle(
                    fontFamily: 'BrunoAceSC',
                    fontSize: 20,
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
      ),
    );
  }
}
