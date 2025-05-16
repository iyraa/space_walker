import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/ui/choice_widget.dart';
import 'package:space_walker/ui/dialogue_widget.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
//import 'package:space_walker/ui/typewriter_text_widget.dart';

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

    print(
      'Available choices: ${availableChoices.map((choice) => choice.option).toList()}',
    );

    //deco var
    final colorScheme = Theme.of(context).colorScheme;
    final double borderWidth = 1.0;
    final Color containerColor = colorScheme.secondary;
    final Color borderColor = colorScheme.primary;
    final double borderPadding = 2.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Sample Grid')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            //double height = constraints.maxHeight;

            // Check if height is below 800
            // if (height < 800 && !_showSnackBar) {
            //   // Show a notification (Snackbar) if height is below 800
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(
            //           'Height is less than the minimum required height of 800.',
            //         ),
            //         duration: Duration(seconds: 3),
            //         backgroundColor: Colors.red,
            //       ),
            //     );
            //   });
            // }
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

                            Text('Login: $mainPlayerName'),
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
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              borderPadding,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: borderWidth,
                                                color: borderColor,
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: containerColor,
                                                border: Border.all(
                                                  width: borderWidth,
                                                  color: borderColor,
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text('info'),
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              borderPadding,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: borderWidth,
                                                color: borderColor,
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: containerColor,
                                                border: Border.all(
                                                  width: borderWidth,
                                                  color: borderColor,
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text('info'),
                                              ),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: borderWidth,
                                          color: borderColor,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          border: Border.all(
                                            width: 1,
                                            color: borderColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: ChoiceWidget(
                                            // isLastLine: isLastLine,
                                            availableChoices: availableChoices,
                                            goToNode: _goToNode,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  //2nd row 3rd col
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: borderWidth,
                                          color: borderColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(borderPadding),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          border: Border.all(
                                            width: borderWidth,
                                            color: borderColor,
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: AnimatedTextKit(
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                  'System Log...',
                                                  textStyle: const TextStyle(
                                                    fontFamily: 'BrunoAceSC',
                                                    color: Color(0xFF9ED7D0),
                                                  ),
                                                  speed: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                ),
                                              ],
                                              repeatForever: true,
                                            ),
                                          ),
                                        ),
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
                                      child: Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondary,
                                          border: Border.all(
                                            width: 1,
                                            color: colorScheme.primary,
                                          ),
                                        ),

                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: colorScheme.primary,
                                            ),
                                          ),
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
                                  ),
                                  SizedBox(width: 10),

                                  //third row, 2nd col
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: borderWidth,
                                          color: borderColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(borderPadding),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          border: Border.all(
                                            width: borderWidth,
                                            color: borderColor,
                                          ),
                                        ),
                                        child: Center(child: Text('30')),
                                      ),
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
