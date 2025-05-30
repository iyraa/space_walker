import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/flag_service.dart';

class StoryService {
  late Box<Node> _nodeBox;

  Node? _currentNode;

  int crew = 8; // Initial crew count
  int fuel = 75; // Initial fuel level
  int morale = 100; // Initial morale level
  int passengers = 24; // Initial passenger count

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

    // Apply effects if present
    if (choice.effects != null && choice.effects is Map<String, dynamic>) {
      _applyEffects(choice.effects as Map<String, dynamic>);
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

  // Add this helper method to handle effects
  void _applyEffects(Map<String, dynamic> effects) {
    // Example: handle crew, fuel, morale, passengers
    if (effects.containsKey('crew')) {
      crew += effects['crew'] as int;
    }
    if (effects.containsKey('fuel')) {
      fuel += effects['fuel'] as int;
    }
    if (effects.containsKey('morale')) {
      morale += effects['morale'] as int;
    }
    if (effects.containsKey('passengers')) {
      passengers += effects['passengers'] as int;
    }
    // Add more effect handling as needed
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
