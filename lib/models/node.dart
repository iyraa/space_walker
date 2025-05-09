import 'package:hive/hive.dart';

part 'node.g.dart'; // Make sure this part file exists after generation

@HiveType(
  typeId: 0,
  adapterName: 'NodeAdapter',
) // Assign a unique typeId for each class
class Node {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String background;

  @HiveField(2)
  final List<DialogueLine> dialogues;

  @HiveField(3)
  final List<Choice> choices;

  Node({
    required this.id,
    required this.background,
    required this.dialogues,
    required this.choices,
  });

  static fromJson(sceneMap) {}
}

@HiveType(typeId: 1, adapterName: 'DialogueLineAdapter')
class DialogueLine {
  @HiveField(0)
  final String character;

  @HiveField(1)
  final String text;

  DialogueLine({required this.character, required this.text});
}

@HiveType(typeId: 2, adapterName: 'ChoiceAdapter') // Unique typeId for Choice
class Choice {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final Map<String, int>? condition;

  @HiveField(2)
  final Map<String, int>? setFlag;

  Choice({required this.text, this.condition, this.setFlag});
}
