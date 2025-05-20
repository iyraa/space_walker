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
  final Puzzle? puzzle;

  @HiveField(4)
  final List<Choice> choices;

  Node({
    required this.id,
    required this.background,
    required this.dialogues,
    this.puzzle,
    required this.choices,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
    id: json['id'] ?? '',
    background: json['background'] ?? '',
    dialogues:
        (json['dialogues'] as List)
            .map((dialogue) => DialogueLine.fromJson(dialogue))
            .toList(),
    puzzle: json['puzzle'] != null ? Puzzle.fromJson(json['puzzle']) : null,
    choices:
        (json['choices'] as List)
            .map((choice) => Choice.fromJson(choice))
            .toList(),
  );
}

@HiveType(typeId: 1, adapterName: 'DialogueLineAdapter')
class DialogueLine {
  @HiveField(0)
  final String character;

  @HiveField(1)
  final String narrative;

  DialogueLine({required this.character, required this.narrative});

  factory DialogueLine.fromJson(Map<String, dynamic> json) => DialogueLine(
    character: json['character'] ?? '',
    narrative: json['narrative'] ?? '',
  );
}

@HiveType(typeId: 2, adapterName: 'ChoiceAdapter') // Unique typeId for Choice
class Choice {
  @HiveField(0)
  final String option;

  @HiveField(1)
  final Map<String, int>? condition;

  @HiveField(2)
  final Map<String, int>? setFlag;

  @HiveField(3)
  final String? nextScene;

  @HiveField(4)
  final String? systemLog;

  Choice({
    required this.option,
    this.condition,
    this.setFlag,
    this.nextScene,
    this.systemLog,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    option: json['option'] ?? '',
    condition:
        (json['condition'] as Map<String, dynamic>?)?.cast<String, int>(),
    setFlag: (json['set_flag'] as Map<String, dynamic>?)?.cast<String, int>(),
    nextScene: json['nextScene'] ?? '',
    systemLog: json['systemLog'] ?? '',
  );
}

@HiveType(typeId: 3, adapterName: 'PuzzleAdapter')
class Puzzle {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String solution;

  @HiveField(3)
  final String flag;

  @HiveField(4)
  final String successMessage;

  @HiveField(5)
  final String failureMessage;

  @HiveField(6)
  final String? hint;

  Puzzle({
    required this.type,
    required this.description,
    required this.solution,
    required this.flag,
    required this.successMessage,
    required this.failureMessage,
    this.hint,
  });

  factory Puzzle.fromJson(Map<String, dynamic> json) => Puzzle(
    type: json['type'] ?? '',
    description: json['description'] ?? '',
    solution: json['solution'] ?? '',
    flag: json['flag'] ?? '',
    successMessage: json['successMessage'] ?? '',
    failureMessage: json['failureMessage'] ?? '',
    hint: json['hint'],
  );
}
