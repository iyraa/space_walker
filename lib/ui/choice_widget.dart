import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/flag_service.dart';

class ChoiceWidget extends StatelessWidget {
  // final bool isLastLine;
  final Choice choice;
  final VoidCallback
  onSelected; // final void Function(Choice) onChoiceSelected;

  const ChoiceWidget({
    super.key,
    required this.onSelected,
    required this.choice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(40, 40, 53, 0.298),
      child: Align(
        //padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Center(
              //padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: onSelected,

                child: Text(choice.option),
              ),
            ),
          ],
        ),
      ),
    );
    // } else {
    //   return SizedBox();
  }
}

//}
