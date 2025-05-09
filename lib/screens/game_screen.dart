import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:space_walker/services/flag_service.dart';
import '../models/node.dart';

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
      print('no intro scene found in Hive'); //debug
    }
  }

  void _nextDialogue() {
    if (_currentNode == null) return;

    if (_dialogueIndex < _currentNode!.dialogues.length - 1) {
      setState(() => _dialogueIndex++);
    }
  }

  void _selectChoice(Choice choice) {
    flagService.applyFlag(choice.setFlag);
    _goToNode(choice.text);
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
    if (_currentNode == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final DialogueLine line = _currentNode!.dialogues[_dialogueIndex];

    final String character = line.character.replaceAll(
      "PLAYER",
      widget.playerName,
    );
    final String text = line.text.replaceAll("PLAYER", widget.playerName);

    final String backgroundPath = _currentNode!.background;

    final bool isLastLine =
        _dialogueIndex == _currentNode!.dialogues.length - 1;

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
      'Available choices: ${availableChoices.map((choice) => choice.text).toList()}',
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundPath, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Color.fromRGBO(255, 255, 255, 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (character.isNotEmpty)
                    Center(
                      child: Image.asset(
                        'assets/images/characters/$character.png',
                        height: 150,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (character.isNotEmpty)
                    Text(
                      '$character:',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  if (!isLastLine)
                    ElevatedButton(
                      onPressed: _nextDialogue,
                      child: const Icon(Icons.arrow_downward),
                    )
                  else
                    ...availableChoices.map((choice) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply the flags and load the next node
                            if (choice.setFlag != null) {
                              flagService.applyFlag(choice.setFlag);
                            }
                            _goToNode(
                              choice.next,
                            ); // Or use `choice.next` if that's the actual ID
                          },
                          child: Text(
                            choice.text,
                          ), // Use choice.text for the button text
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
