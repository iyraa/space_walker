import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SystemLogWidget extends StatelessWidget {
  final List<String> logs;

  const SystemLogWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'System Log...',
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          repeatForever: true,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder:
                (context, index) => AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      logs[index],
                      textStyle: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
          ),
        ),
      ],
    );
  }
}
