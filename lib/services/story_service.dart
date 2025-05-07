import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';

Future<void> loadStoryFromJson() async {
  final nodeBox = Hive.box<Node>('nodeBox');

  print('loading story from JSON...');
  final storyJson = await rootBundle.loadString('assets/json/story.json');
  final List<dynamic> storyData = json.decode(storyJson);
  print('parsed ${storyData.length} story nodes');

  for (var nodeData in storyData) {
    final node = Node(
      id: nodeData['id'],
      narrative: nodeData['narrative'],
      character: nodeData['character'],
      background: nodeData['background'],
      choices:
          (nodeData['choices'] as List)
              .map(
                (choice) => Choice(
                  text: choice['text'],
                  next: choice['next'],
                  setFlag: choice['set_flag'],
                ),
              )
              .toList(),
    );
    await nodeBox.put(node.id, node);
    print('added node: ${node.id}');
  }

  print('story loaded into Hive box.');
}
