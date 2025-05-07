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
  final String narrative;

  @HiveField(2)
  final String character;

  @HiveField(3)
  final String background;

  @HiveField(4)
  final List<Choice> choices;

  @HiveField(5)
  final String? next; //next node if have no choice

  Node({
    required this.id,
    required this.narrative,
    required this.character,
    required this.background,
    required this.choices,
    this.next,
  });

  static fromJson(sceneMap) {}
}

@HiveType(typeId: 1, adapterName: 'ChoiceAdapter') // Unique typeId for Choice
class Choice {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String next;

  @HiveField(2)
  final String? setFlag;

  Choice({required this.text, required this.next, this.setFlag});

  get requiredFlag => null;

  get excludeFlag => null;
}
