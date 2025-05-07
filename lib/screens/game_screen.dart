import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  final Set<String> _flags = {};

  @override
  void initState() {
    super.initState();
    _loadFirstNode();
  }

  void _loadFirstNode() async {
    _nodeBox = Hive.box<Node>('nodeBox');
    final introScene = _nodeBox.get('intro');
    if (introScene != null) {
      setState(() {
        _currentNode = introScene;
      });
    } else {
      print('no intro scene found in Hive'); //debug
    }
  }

  void _goToNode(String nodeID) {
    final nextNode = _nodeBox.get(nodeID);
    if (nextNode != null) {
      setState(() {
        _currentNode = nextNode;
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

    final String character = _currentNode!.character.replaceAll(
      "PLAYER",
      widget.playerName,
    );

    final String narrative = _currentNode!.narrative.replaceAll(
      "PLAYER",
      widget.playerName,
    );
    final String backgroundPath = _currentNode!.background;

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
                    narrative,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ..._currentNode!.choices.map((choice) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (choice.setFlag != null) {
                            _flags.add(choice.setFlag!);
                          }
                          _goToNode(choice.next);
                        },
                        child: Text(choice.text),
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
