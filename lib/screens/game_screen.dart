import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/ui/choice_widget.dart';
import 'package:space_walker/ui/custom_container.dart';
import 'package:space_walker/ui/dialogue_widget.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:space_walker/ui/system_log.dart';

class GameScreen extends StatefulWidget {
  final String playerName;

  const GameScreen({super.key, required this.playerName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Node? _currentNode;
  late Box<Node> _nodeBox;
  int _dialogueIndex = 0;

  List<String> systemLogList = [];
  List<Choice> choices = [];

  @override
  void initState() {
    super.initState();
    _loadFirstNode();
  }

  void _loadFirstNode() async {
    _nodeBox = Hive.box<Node>('nodeBox');
    final introScene = _nodeBox.get('start');
    if (introScene != null) {
      setState(() {
        _currentNode = introScene;
        _dialogueIndex = 0;
      });
    } else {
      debugPrint('no intro scene found in Hive');
    }
  }

  void _nextDialogue() {
    if (_currentNode == null) return;

    if (_dialogueIndex < _currentNode!.dialogues.length - 1) {
      setState(() => _dialogueIndex++);
    }
  }

  // Function to handle choice selection
  void _onChoiceSelected(Choice choice) {
    // Apply flag if it exists
    if (choice.setFlag != null) {
      flagService.applyFlag(choice.setFlag);
    }

    if (choice.systemLog != null) {
      setState(() {
        systemLogList.add(choice.systemLog!);
      });
    }
    _goToNode(choice.nextScene!);
  }

  void _goToNode(String nodeID) {
    final nextNode = _nodeBox.get(nodeID);
    if (nextNode != null) {
      setState(() {
        _currentNode = nextNode;
        _dialogueIndex = 0; //init back to 0 on next node
      });
    } else {
      print('Node not found: $nodeID');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Choice choiceL = _currentNode!.choices['systemLog'];
    final DialogueLine line = _currentNode!.dialogues[_dialogueIndex];

    final String character = line.character.replaceAll(
      "PLAYER",
      widget.playerName,
    );

    final String narrative = line.narrative.replaceAll(
      "PLAYER",
      widget.playerName,
    );

    final String backgroundPath = _currentNode!.background;

    final bool isLastLine =
        _dialogueIndex == _currentNode!.dialogues.length - 1;

    String characterImg = character.replaceAll(' ', '_').toLowerCase();

    bool isPlayer = character == widget.playerName;

    String mainPlayerName = widget.playerName;

    // final logs =
    //     _currentNode!.choices
    //         .where((choice) => choice.systemLog != null)
    //         .map((c) => c.systemLog!)
    //         .toList();

    // Filter choices based on conditions (make sure condition is not null)
    final availableChoices =
        isLastLine
            ? _currentNode!.choices
                .where(
                  (choice) =>
                      choice.condition != null &&
                      flagService.areConditionsMet(choice.condition!),
                )
                .toList()
            : [];
    //  final List systemLogs = availableChoices
    //   .where(
    //     (choice) =>
    //         choice.systemLog != null && choice.systemLog.isNotEmpty,
    //   )
    //   .map((choice) => choice.systemLog)
    //   .toList();

    // if (availableChoices.isNotEmpty) {
    //   for (final choice in availableChoices) {
    //     if (choice.systemLog != null) {
    //       systemLogList.add(choice.systemLog!);
    //     }
    //   }
    // }

    print(
      'Available choices: ${availableChoices.map((choice) => choice.option).toList()}',
    );

    // for (final choice in _currentNode!.choices) {
    //   if (choice.systemLog != null) {
    //     final logLine = choice.systemLog!;
    //     // do something with logLine
    //     debugPrint('$logLine');
    //   }
    // }

    //deco var
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Space Walker',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            print(
              'Height: ${constraints.maxHeight}, Width: ${constraints.maxWidth}',
            );

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 800,
                minWidth: constraints.maxWidth,
              ),
              child: Container(
                decoration: BoxDecoration(color: colorScheme.secondary),
                child: Column(
                  children: [
                    //Top
                    Container(
                      height: 30,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('spacewalker'),

                            AnimatedTextKit(
                              animatedTexts: [
                                FlickerAnimatedText('Login: $mainPlayerName'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SizedBox(width: 5),

                    //2nd
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //2nd row 1st col
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: CustomContainer(
                                            padding: EdgeInsets.all(10.0),
                                            child: Center(child: Text('info1')),
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        Expanded(
                                          child: CustomContainer(
                                            padding: EdgeInsets.all(10.0),
                                            child: const Center(
                                              child: Text('info'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  //2nd row 2nd col
                                  Expanded(
                                    flex: 3,
                                    child: CustomContainer(
                                      padding: EdgeInsets.all(1.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              availableChoices.map((choice) {
                                                return ChoiceWidget(
                                                  choice: choice,
                                                  onSelected:
                                                      () => _onChoiceSelected(
                                                        choice,
                                                      ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  //2nd row 3rd col
                                  Expanded(
                                    flex: 1,
                                    child: CustomContainer(
                                      padding: EdgeInsets.all(10.0),
                                      child: SystemLogWidget(
                                        logs: systemLogList,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),
                            //third row
                            //third row, 1st col
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: GestureDetector(
                                      onTap: _nextDialogue,
                                      child: CustomContainer(
                                        padding: EdgeInsets.all(5.0),
                                        child: DialogueWidget(
                                          character: character,
                                          narrative: narrative,
                                          isLastLine: isLastLine,
                                          // characterImg: characterImg,
                                          // availableChoices: [],
                                          // goToNode: _goToNode,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  //third row, 2nd col
                                  Expanded(
                                    flex: 1,
                                    child: CustomContainer(
                                      padding: EdgeInsets.all(5.0),
                                      child: Center(child: Text('30')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
