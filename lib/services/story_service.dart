import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/flag_service.dart';

class StoryService {
  late Box<Node> _nodeBox;

  Node? _currentNode;

  Future<void> init() async {
    _nodeBox = await Hive.openBox<Node>('nodes');
    await loadStoryFromJson();
  }

  Node? get currentNode => _currentNode;

  Future<void> loadFirstNode(String id) async {
    final startScene = _nodeBox.get(id);
    if (startScene != null) {
      _currentNode = startScene;
      debugPrint('Loaded first node: ${startScene.id}');
    } else {
      debugPrint('Node with id $id not found');
    }
  }

  Future<void> setFlag(String key, bool value) async {
    final flagBox = await Hive.openBox('flags');
    flagBox.put(key, value);
  }

  bool checkCondition(Map<String, bool>? condition) {
    if (condition == null || condition.isEmpty) {
      return true;
    }
    for (var entry in condition.entries) {
      final flagValue = flagService.getFlag(entry.key);
      if (flagValue == null || flagValue != entry.value) {
        debugPrint('Condition not met for ${entry.key}');
        return false;
      }
    }
    return true;
  }

  List<Choice> availableChoices() {
    if (_currentNode == null) return [];
    return _currentNode!.choices.where((choice) {
      return checkCondition(choice.condition);
    }).toList();
  }

  Future<bool> applyChoiceAndCheckAdvance(Choice choice) async {
    if (choice.setFlag != null) {
      flagService.applyFlag(choice.setFlag!);
    }
    bool didAdvance = false;
    if (choice.nextScene != null && choice.nextScene!.isNotEmpty) {
      _currentNode = _nodeBox.get(choice.nextScene);
      didAdvance = true;
      if (_currentNode == null) {
        debugPrint('Next node with id ${choice.nextScene} not found');
      }
    }
    return didAdvance;
  }

  Future<void> loadStoryFromJson() async {
    // Load story data from JSON //
    debugPrint('loading story from JSON...');
    final storyJson = await rootBundle.loadString('json/spacewalker.json');
    final List<dynamic> storyData = json.decode(storyJson);
    debugPrint('Succesfully parsed ${storyData.length} story nodes!!');

    for (var nodeData in storyData) {
      final node = Node.fromJson(nodeData);
      await _nodeBox.put(node.id, node);
      print('added node: ${node.id}');
    }
  }
}
