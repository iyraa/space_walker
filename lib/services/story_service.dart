import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';

Future<void> loadStoryFromJson() async {
  final nodeBox = await Hive.openBox<Node>('nodeBox');

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
                  text: dialogue['text'],
                ),
              )
              .toList(),
      choices:
          choicesList.map((choice) {
            // Convert setFlag and condition into Map<String, int> if they exist
            Map<String, int>? setFlag =
                choice['set_flag'] != null
                    ? Map<String, int>.from(choice['set_flag'])
                    : null;
            Map<String, int>? condition =
                choice['condition'] != null
                    ? Map<String, int>.from(choice['condition'])
                    : null;

            return Choice(
              text: choice['text'],
              setFlag: setFlag,
              condition: condition,
            );
          }).toList(),
    );

    await nodeBox.put(node.id, node);
    print('added node: ${node.id}');
  }

  print('story loaded into Hive box.');
}
