import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
// import 'package:space_walker/services/flag_service.dart';

class StoryService {
  static Future<void> loadStoryFromJson() async {
    final nodeBox = await Hive.openBox<Node>('nodes');
    // final Set<String> allFlags =
    //     {}; // Added this line to collect all flag keys dynamically

    // Load story data from JSON //
    debugPrint('loading story from JSON...');
    final storyJson = await rootBundle.loadString('assets/json/story.json');
    final List<dynamic> storyData = json.decode(
      storyJson,
    );
    debugPrint('Succesfully parsed ${storyData.length} story nodes!!');

    for (var nodeData in storyData) {
      final node = Node.fromJson(nodeData);
      await nodeBox.put(node.id, node);
      print('added node: ${node.id}');
    }

    print('story loaded into Hive box and flags initialized.');
  }
}
