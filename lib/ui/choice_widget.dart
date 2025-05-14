// choice_widget.dart
import 'package:flutter/material.dart';
import 'package:space_walker/services/flag_service.dart';

class ChoiceWidget extends StatelessWidget {
  final bool isLastLine;
  final List<dynamic> availableChoices;
  final void Function(String) goToNode;

  const ChoiceWidget({
    super.key,
    required this.isLastLine,
    required this.availableChoices,
    required this.goToNode,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasChoices = isLastLine && availableChoices.isNotEmpty;

    if (hasChoices) {
      return Column(
        children: [
          ...availableChoices.map((choice) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (choice.setFlag != null) {
                    flagService.applyFlag(choice.setFlag);
                  }
                  goToNode(choice.nextScene);
                },
                child: Text(choice.option),
              ),
            );
          }).toList(),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
