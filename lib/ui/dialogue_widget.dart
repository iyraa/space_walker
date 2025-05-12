import 'package:flutter/material.dart';

class DialogueWidget extends StatelessWidget {
  final String character;
  final String narrative;
  final bool isLastLine;
  final VoidCallback onNext;
  final String characterImg;

  const DialogueWidget({
    super.key,
    required this.character,
    required this.narrative,
    required this.isLastLine,
    required this.onNext,
    required this.characterImg,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Character image patlh: $characterImg');

    return GestureDetector(
      onTap: onNext, // Trigger the onContinue callback when tapped
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            // Character image (if available)
            if (character.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'characters/$characterImg.png',
                  width: 50, // Set a fixed size for the image
                  height: 50,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character name
                Text(
                  character,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),

                // Dialogue/narrative text
                Text(
                  narrative,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
