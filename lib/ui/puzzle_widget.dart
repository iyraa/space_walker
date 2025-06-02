import 'dart:math';
import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:audioplayers/audioplayers.dart';

class PuzzleWidget extends StatefulWidget {
  final NodeContent puzzle;
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

  // For word and symbol puzzles
  late List<String> _randomizedLetters;
  final List<String> _defaultSymbols = [
    '★',
    '☀',
    '☂',
    '♠',
    '♣',
    '♥',
    '♦',
    '♪',
    '☯',
    '☢',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.puzzle.puzzleType == 'wordEntry' &&
        widget.puzzle.solution != null) {
      _randomizedLetters = widget.puzzle.solution!.split('')..shuffle(Random());
    } else {
      _randomizedLetters = [];
    }
  }

  void _appendInput(String input) async {
    controller.text += input;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    await _audioPlayer.play(AssetSource('audio/sfx/pin.mp3'));
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
    Widget inputPad = const SizedBox.shrink();

    if (widget.puzzle.puzzleType == 'codeEntry') {
      inputPad = _buildNumberPad();
    } else if (widget.puzzle.puzzleType == 'wordEntry') {
      inputPad = _buildWordPad();
    } else if (widget.puzzle.puzzleType == 'symbolEntry') {
      inputPad = _buildSymbolPad();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.puzzle.description ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextField(
              controller: controller,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Your answer'),
            ),
            const SizedBox(height: 8),
            inputPad,
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
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
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
            onPressed: () => _appendInput('0'),
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
            onPressed: () => _appendInput('${index + 1}'),
            child: Text('${index + 1}'),
          );
        }
      },
    );
  }

  Widget _buildWordPad() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._randomizedLetters.map(
          (letter) => ElevatedButton(
            onPressed: () => _appendInput(letter),
            child: Text(letter),
          ),
        ),
        ElevatedButton(
          onPressed: _backspace,
          child: const Icon(Icons.backspace),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.onSubmit != null) {
              widget.onSubmit!(controller.text);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildSymbolPad() {
    // Use puzzle.symbols if provided, else default
    final symbols = widget.puzzle.symbols ?? _defaultSymbols;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...symbols.map(
          (symbol) => ElevatedButton(
            onPressed: () => _appendInput(symbol),
            child: Text(symbol, style: const TextStyle(fontSize: 24)),
          ),
        ),
        ElevatedButton(
          onPressed: _backspace,
          child: const Icon(Icons.backspace),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.onSubmit != null) {
              widget.onSubmit!(controller.text);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
