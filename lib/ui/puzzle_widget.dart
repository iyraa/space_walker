import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';

class PuzzleWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              puzzle.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (puzzle.type == 'codeEntry') ...[
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Enter code'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (onSubmit != null) {
                    onSubmit!(controller.text);
                  }
                },
                child: const Text('Submit'),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
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
