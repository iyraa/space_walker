import 'package:flutter/material.dart';
import 'package:space_walker/services/flag_service.dart';

class ChoiceWidget extends StatelessWidget {
  // final bool isLastLine;
  final List<dynamic> availableChoices;
  final void Function(String) goToNode;
  // final void Function(Choice) onChoiceSelected;

  const ChoiceWidget({
    super.key,
    //required this.isLastLine,
    required this.availableChoices,
    required this.goToNode,
    // required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    //final bool hasChoices = isLastLine && availableChoices.isNotEmpty;

    //if (hasChoices) {
    return Container(
      color: Color.fromRGBO(40, 40, 53, 0.298),
      child: Align(
        //padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            ...availableChoices.map((choice) {
              return Center(
                //padding: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                  onPressed: () {
                    if (choice.setFlag != null) {
                      flagService.applyFlag(
                        choice.setFlag,
                      ); // Apply the flag (if any)
                    }
                    // Go to the next scene based on the choice
                    goToNode(choice.nextScene!);
                  },
                  child: Text(choice.option),
                ),
              );
            }),
          ],
        ),
      ),
    );
    // } else {
    //   return SizedBox();
  }
}

//}
