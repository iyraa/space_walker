import 'package:flutter/material.dart';
import 'package:space_walker/models/node.dart';
import 'package:space_walker/services/story_service.dart';
import 'package:space_walker/ui/choice_widget.dart';
import 'package:space_walker/ui/custom_container.dart';
import 'package:space_walker/ui/dialogue_widget.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:space_walker/ui/error_overlay.dart';
import 'package:space_walker/ui/system_log.dart';
import 'package:space_walker/ui/puzzle_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_background/animated_background.dart';

class GameScreen extends StatefulWidget {
  final String playerName;

  const GameScreen({super.key, required this.playerName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final StoryService _storyService = StoryService();
  int _dialogueIndex = 0;
  var currentNode;
  bool _showPuzzleWarning = false;
  late VideoPlayerController _videoController;

  Puzzle? _activePuzzle;
  String? _puzzleErrorMessage;
  Choice? _pendingChoice;

  List<String> systemLogList = [];
  List<Choice> choices = [];

  @override
  void initState() {
    super.initState();
    initialize();
    _videoController =
        VideoPlayerController.asset('/background/moving_bg.mov')
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    await _storyService.init();
    await _storyService.loadFirstNode('start');

    // Reset flag when starting a new game
    await flagService.init();
    await flagService.clearFlags();

    setState(() {
      _dialogueIndex = 0;
      currentNode = _storyService.currentNode;
    });
  }

  void _onChoiceSelected(Choice choice) async {
    if (choice.puzzle != null) {
      setState(() {
        _activePuzzle = choice.puzzle;
        _pendingChoice = choice;
      });
    } else {
      await _storyService.applyChoice(choice);
      setState(() {
        currentNode = _storyService.currentNode;
        _dialogueIndex = 0;
        systemLogList.add(choice.systemLog!);
      });
    }
  }

  void _onPuzzleSubmit(String solution) async {
    if (_activePuzzle == null || _pendingChoice == null) return;

    // Example: check solution
    if (solution == _activePuzzle!.solution) {
      // Optionally show success message
      await _storyService.applyChoice(_pendingChoice!);
      setState(() {
        _activePuzzle = null;
        _pendingChoice = null;
        _puzzleErrorMessage = null;
        _showPuzzleWarning = false;
        currentNode = _storyService.currentNode;
        _dialogueIndex = 0;
      });
    } else {
      // Optionally show failure message (e.g., Snackbar)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(_activePuzzle!.failureMessage ?? "Incorrect!")),
      // );
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
        appBar: AppBar(
          title: Text(
            'Space Walker',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Stack(
          children: [
            // Video background
            // if (_videoController.value.isInitialized)
            //   SizedBox.expand(
            //     child: FittedBox(
            //       fit: BoxFit.cover,
            //       child: SizedBox(
            //         width: _videoController.value.size.width,
            //         height: _videoController.value.size.height,
            //         child: VideoPlayer(_videoController),
            //       ),
            //     ),
            //   ),
            // Main game UI
            LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 800,
                    minWidth: constraints.maxWidth,
                  ),
                  child: AnimatedBackground(
                    behaviour: RacingLinesBehaviour(
                      direction: LineDirection.Ltr,
                      numLines: 10,
                    ),
                    vsync: this,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _showPuzzleWarning ? Colors.red.shade900 : null,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('spacewalker'),
                                  AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        'Login: ${widget.playerName}',
                                      ),
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
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: CustomContainer(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Center(
                                                    child: Text(
                                                      '${currentNode!.dialogues.length}',
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // SizedBox(height: 10),
                                              Expanded(
                                                child: CustomContainer(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Center(
                                                    child: Text(
                                                      'siti: ${flagService.getFlag('siti') ?? 0}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // ...your main content here...
                                                    ],
                                                  ),
                                                ),
                                                if (_activePuzzle != null)
                                                  Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        PuzzleWidget(
                                                          puzzle:
                                                              _activePuzzle!,
                                                          onSubmit:
                                                              _onPuzzleSubmit,
                                                          errorMessage:
                                                              _puzzleErrorMessage,
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _activePuzzle =
                                                                  null;
                                                              _pendingChoice =
                                                                  null;
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
                                                      color: Colors.black
                                                          .withOpacity(0.6),
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
                                                                      choice:
                                                                          choice,
                                                                      onSelected:
                                                                          () => _onChoiceSelected(
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child:
                                                      (_dialogueIndex <
                                                              currentNode!
                                                                  .dialogues
                                                                  .length)
                                                          ? DialogueWidget(
                                                            dialogue:
                                                                currentNode!
                                                                    .dialogues[_dialogueIndex],
                                                            onNext:
                                                                _nextDialogue,
                                                            isLastLine:
                                                                isLastLine,
                                                            playerName:
                                                                widget
                                                                    .playerName,
                                                          )
                                                          : SizedBox.shrink(),
                                                ),
                                              ],
                                            ),
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
                  ),
                );
              },
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
