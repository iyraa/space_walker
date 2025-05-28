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
        color: Colors.red.withOpacity(0.1),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Expanded(
                        child: SizedBox(),
                      ), // pushes icon to bottom if space
                      if (!isLastLine)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.rocket_launch_outlined,
                            color: Color(0xFF9ED7D0),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
