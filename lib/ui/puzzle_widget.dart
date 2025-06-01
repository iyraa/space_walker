import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:audioplayers/audioplayers.dart';

class PuzzleWidget extends StatefulWidget {
  final Puzzle puzzle;
  final void Function(String)? onSubmit;
  final String? errorMessage;

  const PuzzleWidget({
    super.key,
    required this.puzzle,
    this.onSubmit,
    this.errorMessage,
  });

  @override
  State<PuzzleWidget> createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  final TextEditingController controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _appendDigit(String digit) async {
    controller.text += digit;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    await _audioPlayer.play(AssetSource('audio/sfx/click.mp3'));
    setState(() {});
  }

  void _backspace() async {
    if (controller.text.isNotEmpty) {
      controller.text = controller.text.substring(
        0,
        controller.text.length - 1,
      );
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
      await _audioPlayer.play(AssetSource('audio/sfx/click.mp3'));
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.puzzle.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.puzzle.type == 'codeEntry') ...[
              TextField(
                controller: controller,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Enter code'),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return ElevatedButton(
                      onPressed: _backspace,
                      child: const Icon(Icons.backspace),
                    );
                  } else if (index == 10) {
                    return ElevatedButton(
                      onPressed: () => _appendDigit('0'),
                      child: const Text('0'),
                    );
                  } else if (index == 11) {
                    return ElevatedButton(
                      onPressed: () {
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(controller.text);
                        }
                      },
                      child: const Text('OK'),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => _appendDigit('${index + 1}'),
                      child: Text('${index + 1}'),
                    );
                  }
                },
              ),
              if (widget.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
            // Add more puzzle types here as needed
          ],
        ),
      ),
    );
  }
}
