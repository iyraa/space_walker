import 'package:hive/hive.dart';

part 'node.g.dart';

@HiveType(typeId: 0, adapterName: 'NodeAdapter')
class Node {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String background;

  @HiveField(2)
  final String? music;

  @HiveField(3)
  final List<NodeContent> content;

  Node({
    required this.id,
    required this.background,
    this.music,
    required this.content,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
    id: json['id'] ?? '',
    background: json['background'] ?? '',
    music: json['music'],
    content:
        (json['content'] as List).map((e) => NodeContent.fromJson(e)).toList(),
  );
}

@HiveType(typeId: 2, adapterName: 'NodeContentAdapter')
class NodeContent {
  @HiveField(0)
  final String type; // "dialogue", "choice", "puzzle"

  // Dialogue
  @HiveField(1)
  final String? character;
  @HiveField(2)
  final String? narrative;

  // Puzzle
  @HiveField(3)
  final String? puzzleType;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String? solution;
  @HiveField(6)
  final Map<String, bool>? setFlag;
  @HiveField(7)
  final String? successMessage;
  @HiveField(8)
  final String? failureMessage;
  @HiveField(9)
  final List<String>? symbols;

  // Choice
  @HiveField(10)
  final String? option;
  @HiveField(11)
  final String? nextNodeId;
  @HiveField(12)
  final Map<String, bool>? condition;
  @HiveField(13)
  final String? systemLog;

  NodeContent({
    required this.type,
    this.character,
    this.narrative,
    this.puzzleType,
    this.description,
    this.solution,
    this.setFlag,
    this.successMessage,
    this.failureMessage,
    this.symbols,
    this.option,
    this.nextNodeId,
    this.condition,
    this.systemLog,
  });

  factory NodeContent.fromJson(Map<String, dynamic> json) => NodeContent(
    type: json['type'] ?? '',
    character: json['character'],
    narrative: json['narrative'],
    puzzleType: json['puzzle_type'],
    description: json['description'],
    solution: json['solution'],
    setFlag: (json['set_flag'] as Map?)?.cast<String, bool>(),
    successMessage: json['successMessage'],
    failureMessage: json['failureMessage'],
    symbols: (json['symbols'] as List?)?.map((e) => e.toString()).toList(),
    option: json['option'],
    nextNodeId: json['next_node_id'],
    condition: (json['condition'] as Map?)?.cast<String, bool>(),
    systemLog: json['systemLog'],
  );
}

@HiveType(typeId: 3, adapterName: 'CharacterAdapter')
class Character {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Character({required this.id, required this.name});

  factory Character.fromJson(Map<String, dynamic> json) =>
      Character(id: json['id'] ?? '', name: json['name'] ?? '');
}
