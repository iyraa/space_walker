import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/story_service.dart';
import 'package:space_walker/ui/choice_widget.dart';
import 'package:space_walker/ui/constellation_background.dart';
import 'package:space_walker/ui/custom_container.dart';
import 'package:space_walker/ui/dialogue_widget.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:space_walker/ui/error_overlay.dart';
import 'package:space_walker/ui/system_log_widget.dart';
import 'package:space_walker/ui/puzzle_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

//do story line
//adjust dialogue hover
//decide what to do with the column = spaceship intergrity or spaceship status or people statuses.
//adjust the system log aesthetic.
//add time and date to the top bar with spacewalker blinking.
class GameScreen extends StatefulWidget {
  final String playerName;

  const GameScreen({super.key, required this.playerName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final StoryService _storyService = StoryService();
  int _dialogueIndex = 0;
  Node? currentNode;
  bool _showPuzzleWarning = false;
  late VideoPlayerController _videoController;

  late final AudioPlayer _bgmPlayer;
  String? _currentMusic;

  Puzzle? _activePuzzle;
  String? _puzzleErrorMessage;
  Choice? _pendingChoice;

  List<String> systemLogList = [];
  List<Choice> choices = [];

  @override
  void initState() {
    super.initState();
    _bgmPlayer = AudioPlayer();
    initialize();
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    // Stop any currently playing music before restarting
    await _bgmPlayer.stop();

    await _storyService.init();
    await _storyService.loadFirstNode('1: Start');

    // Reset flag when starting a new game
    await flagService.init();
    await flagService.clearFlags();

    setState(() {
      _dialogueIndex = 0;
      currentNode = _storyService.currentNode;
    });
    await _playNodeMusic();
  }

  Future<void> _playNodeMusic() async {
    final music = currentNode?.music;
    if (music != null && music != _currentMusic) {
      _currentMusic = music;
      await _bgmPlayer.stop();
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _bgmPlayer.play(AssetSource('audio/music/$music'), volume: 0.5);
    }
  }

  void _onChoiceSelected(Choice choice) async {
    if (choice.puzzle != null) {
      setState(() {
        _activePuzzle = choice.puzzle;
        _pendingChoice = choice;
      });
    } else {
      final didAdvance = await _storyService.applyChoiceAndCheckAdvance(choice);
      setState(() {
        currentNode = _storyService.currentNode;
        if (didAdvance) {
          _dialogueIndex = 0;
        }
        systemLogList.add(choice.systemLog!);
      });
    }
  }

  void _onPuzzleSubmit(String solution) async {
    if (_activePuzzle == null || _pendingChoice == null) return;

    if (solution == _activePuzzle!.solution) {
      // Apply puzzle flag if present
      if (_activePuzzle!.setFlag != null) {
        flagService.applyFlag(_activePuzzle!.setFlag!);
      }
      final didAdvance = await _storyService.applyChoiceAndCheckAdvance(
        _pendingChoice!,
      );
      setState(() {
        _activePuzzle = null;
        _pendingChoice = null;
        currentNode = _storyService.currentNode;
        if (didAdvance) {
          _dialogueIndex = 0;
        }
      });
    } else {
      setState(() {
        _puzzleErrorMessage = _activePuzzle!.failureMessage ?? "Wrong answer!";
        _showPuzzleWarning = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _puzzleErrorMessage = null;
          _showPuzzleWarning = false;
        });
      });
    }
  }

  void _nextDialogue() {
    if (currentNode == null) return;

    if (_dialogueIndex < currentNode!.dialogues.length - 1) {
      setState(() => _dialogueIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = _storyService.currentNode;

    if (node == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isLastLine = _dialogueIndex == currentNode!.dialogues.length - 1;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Space Walker',
        //     style: TextStyle(color: Theme.of(context).colorScheme.primary),
        //   ),
        // ),
        body: Stack(
          children: [
            const AnimatedConstellationBackground(),

            // Main game UI
            Container(
              decoration: BoxDecoration(
                color:
                    _showPuzzleWarning
                        ? Colors.red.shade900
                        : Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.3),
              ),
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
                              TyperAnimatedText('Login: ${widget.playerName}'),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CustomContainer(
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                AnimatedTextKit(
                                                  animatedTexts: [
                                                    TyperAnimatedText(
                                                      'NUR 10',
                                                      textStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                      speed: const Duration(
                                                        milliseconds: 100,
                                                      ),
                                                    ),
                                                  ],
                                                  repeatForever: true,
                                                ),
                                                Text(
                                                  'Crew Morale: ${_storyService.morale}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  'Number of Crew: ${_storyService.crew}',
                                                ),
                                                Text(
                                                  'Number of passengers: ${_storyService.passengers}',
                                                ),
                                                Text(
                                                  'Fuel status: ${_storyService.fuel}%',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // SizedBox(height: 10),
                                      Expanded(
                                        child: CustomContainer(
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                AnimatedTextKit(
                                                  animatedTexts: [
                                                    TyperAnimatedText(
                                                      'M',
                                                      textStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                      speed: const Duration(
                                                        milliseconds: 100,
                                                      ),
                                                    ),
                                                  ],
                                                  repeatForever: true,
                                                ),
                                                Text(
                                                  'siti: ${flagService.getFlag('siti') ?? 0}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //SizedBox(width: 10),
                                //2nd row 2nd col
                                Expanded(
                                  flex: 3,
                                  child: CustomContainer(
                                    padding: EdgeInsets.all(1.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // ...your main content here...
                                            ],
                                          ),
                                        ),
                                        if (_activePuzzle != null)
                                          Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                PuzzleWidget(
                                                  puzzle: _activePuzzle!,
                                                  onSubmit: _onPuzzleSubmit,
                                                  errorMessage:
                                                      _puzzleErrorMessage,
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _activePuzzle = null;
                                                      _pendingChoice = null;
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Close Puzzle',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        else if (isLastLine)
                                          Positioned.fill(
                                            child: Container(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children:
                                                      _storyService
                                                          .availableChoices()
                                                          .map(
                                                            (
                                                              choice,
                                                            ) => ChoiceWidget(
                                                              choice: choice,
                                                              onSelected:
                                                                  () =>
                                                                      _onChoiceSelected(
                                                                        choice,
                                                                      ),
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                //SizedBox(width: 10),

                                //2nd row 3rd col
                                Expanded(
                                  flex: 1,
                                  child: CustomContainer(
                                    padding: EdgeInsets.all(10.0),
                                    child: SystemLogWidget(
                                      logs: systemLogList,
                                      playerName: widget.playerName,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //SizedBox(height: 10),
                          //third row
                          //third row, 1st col
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: CustomContainer(
                                    padding: EdgeInsets.all(5.0),
                                    child:
                                        (_dialogueIndex <
                                                currentNode!.dialogues.length)
                                            ? DialogueWidget(
                                              dialogue:
                                                  currentNode!
                                                      .dialogues[_dialogueIndex],
                                              onNext: _nextDialogue,
                                              isLastLine: isLastLine,
                                              playerName: widget.playerName,
                                            )
                                            : SizedBox.shrink(),
                                  ),
                                ),
                                // SizedBox(width: 10),
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

            // Error overlay
            if (_showPuzzleWarning)
              ErrorOverlay(
                errorMessage: _puzzleErrorMessage ?? "An error occurred",
              ),
          ],
        ),
      ),
    );
  }
}
