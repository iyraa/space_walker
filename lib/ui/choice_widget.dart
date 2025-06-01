import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:audioplayers/audioplayers.dart';

class ChoiceWidget extends StatelessWidget {
  final NodeContent choice;
  final VoidCallback onSelected;

  const ChoiceWidget({
    super.key,
    required this.onSelected,
    required this.choice,
  });

  void _playSfx() {
    final player = AudioPlayer();
    player.play(AssetSource('audio/sfx/click.mp3'), volume: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    _playSfx();
                    onSelected();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: Text(choice.option ?? ''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
