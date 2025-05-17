import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/flag_service.dart';

Future<void> loadStoryFromJson() async {
  final nodeBox = await Hive.openBox<Node>('nodeBox');
  final Set<String> allFlags =
      {}; // Added this line to collect all flag keys dynamically

  print('loading story from JSON...');
  final storyJson = await rootBundle.loadString('assets/json/story.json');
  final List<dynamic> storyData = json.decode(
    storyJson,
  ); // This should be a list, not a map

  print('parsed ${storyData.length} story nodes');

  for (var nodeData in storyData) {
    // Ensure that dialogues and choices are correctly parsed as lists
    final dialoguesList = List<Map<String, dynamic>>.from(
      nodeData['dialogues'],
    );
    final choicesList = List<Map<String, dynamic>>.from(nodeData['choices']);

    final node = Node(
      id: nodeData['id'],
      background: nodeData['background'],
      dialogues:
          dialoguesList
              .map(
                (dialogue) => DialogueLine(
                  character: dialogue['character'],
                  narrative: dialogue['narrative'],
                ),
              )
              .toList(),
      choices:
          choicesList.map((choice) {
            // Collect setFlag and condition into Map<String, int> if they exist
            Map<String, int>? setFlag =
                choice['set_flag'] != null
                    ? Map<String, int>.from(choice['set_flag'])
                    : null;
            Map<String, int>? condition =
                choice['condition'] != null
                    ? Map<String, int>.from(choice['condition'])
                    : null;

            // Collect all flag keys dynamically
            if (setFlag != null) allFlags.addAll(setFlag.keys);
            if (condition != null) allFlags.addAll(condition.keys);

            return Choice(
              option: choice['option'],
              nextScene: choice['nextScene'],
              setFlag: setFlag,
              condition: condition,
              
            );
          }).toList(),
    );

    await nodeBox.put(node.id, node);
    print('added node: ${node.id}');
  }

  // Initialize missing flags after processing all nodes
  for (var flag in allFlags) {
    if (!flagService.hasFlag(flag)) {
      print(
        'Initializing flag: $flag',
      ); // Debugging output to track initialization
      flagService.applyFlag({flag: 0});
    }
  }

  print('story loaded into Hive box and flags initialized.');
}
