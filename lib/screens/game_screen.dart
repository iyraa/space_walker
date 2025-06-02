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
import 'package:space_walker/ui/music_playlist.dart';
import 'package:space_walker/ui/system_log_widget.dart';
import 'package:space_walker/ui/puzzle_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

//do story line
//adjust dialogue hover
//decide what to do with the column = spaceship intergrity or spaceship status or people statuses.
//adjust the system log aesthetic.
//add time and date to the top bar with spacewalker blinking.

//keyboard sound
//success sound
//fail sound
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

  /* MUSIC MANAGEMENT */
  late final AudioPlayer _sfxPlayer;
  late final AudioPlayer _playlistPlayer;
  String? _currentAudio;

  NodeContent? _activePuzzle;
  String? _puzzleErrorMessage;
  NodeContent? _pendingChoice; // Use NodeContent for choices now

  List<String> systemLogList = [];
  List<NodeContent> choices = []; // Choices are NodeContent with type 'choice'
  List<NodeContent> dialogueHistory =
      []; // Dialogues are NodeContent with type 'dialogue'

  bool _wasLoggedIn = false;

  bool _showBackgroundPanel = false;
  bool _backgroundFlicker = false;
  int _flickerCount = 0;

  bool _showPuzzleWarning = false;

  @override
  void initState() {
    super.initState();
    _sfxPlayer = AudioPlayer();
    _playlistPlayer = AudioPlayer();
    initialize();
  }

  @override
  void dispose() {
    //_sfxPlayer.dispose();
    //_playlistPlayer.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    // Stop any currently playing music before restarting
    await _sfxPlayer.stop();
    await _playlistPlayer.stop();

    await _storyService.init();
    await _storyService.loadFirstNode('1_START');

    // Reset flag when starting a new game
    await flagService.init();
    await flagService.clearFlags();

    setState(() {
      _dialogueIndex = 0;
      currentNode = _storyService.currentNode;
      dialogueHistory = [];
      final dialogues =
          currentNode!.content.where((c) => c.type == 'dialogue').toList();
      if (dialogues.isNotEmpty) {
        dialogueHistory.add(dialogues[0]);
      }
      _activePuzzle = getActivePuzzle();
    });
    await _playNodeMusic();
  }

  Future<void> _playNodeMusic() async {
    final audio = currentNode?.audio;
    if (audio != null && audio != _currentAudio) {
      _currentAudio = audio;
      await _sfxPlayer.stop();
      //await _sfxPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _sfxPlayer.play(AssetSource('audio/sfx/$audio'), volume: 0.5);
    }
  }

  void _onChoiceSelected(NodeContent choice) async {
    final didAdvance = await _storyService.applyChoiceAndCheckAdvance(choice);
    setState(() {
      currentNode = _storyService.currentNode;
      if (didAdvance) {
        _dialogueIndex = 0;
      }
      if (choice.systemLog != null) {
        systemLogList.add(choice.systemLog!);
      }
      choices.removeWhere((c) => c == choice);
      _activePuzzle = getActivePuzzle(); // Check if a puzzle should now appear
    });
  }

  void _onPuzzleSubmit(String answer) async {
    if (_activePuzzle == null) return;

    if (answer == _activePuzzle!.solution) {
      if (_activePuzzle!.setFlag != null) {
        flagService.applyFlag(_activePuzzle!.setFlag!);
      }
      // Move to next node if specified
      if (_activePuzzle!.nextNodeId != null &&
          _activePuzzle!.nextNodeId!.isNotEmpty) {
        await _storyService.loadFirstNode(_activePuzzle!.nextNodeId!);
        setState(() {
          currentNode = _storyService.currentNode;
          _dialogueIndex = 0;
          _activePuzzle = getActivePuzzle();
        });
      } else {
        setState(() {
          _activePuzzle = null;
        });
      }
    } else {
      setState(() {
        _puzzleErrorMessage = _activePuzzle!.failureMessage ?? "Wrong answer!";
        _showPuzzleWarning = true;
      });
    }
  }

  void _nextDialogue() {
    if (currentNode == null) return;
    final dialogues =
        currentNode!.content.where((c) => c.type == 'dialogue').toList();
    if (_dialogueIndex < dialogues.length - 1) {
      setState(() => _dialogueIndex++);
      dialogueHistory.add(dialogues[_dialogueIndex]);
    }
  }

  void _startBackgroundFlicker() {
    _flickerCount = 0;
    _backgroundFlicker = true;
    _showBackgroundPanel = false;
    Future.doWhile(() async {
      setState(() {
        _showBackgroundPanel = !_showBackgroundPanel;
      });
      _flickerCount++;
      await Future.delayed(const Duration(milliseconds: 120));
      return _flickerCount < 6; // Flicker 3 times (6 toggles)
    }).then((_) {
      setState(() {
        _showBackgroundPanel = true;
        _backgroundFlicker = false;
      });
    });
  }

  NodeContent? getActivePuzzle() {
    if (currentNode == null) return null;
    for (final c in currentNode!.content) {
      if (c.type == 'puzzle' && _storyService.checkCondition(c.condition)) {
        return c;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final node = _storyService.currentNode;
    if (node == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Get all dialogues for the current node
    final dialogues =
        currentNode!.content.where((c) => c.type == 'dialogue').toList();
    final bool isLastLine = _dialogueIndex == dialogues.length - 1;

    // Get available choices for the current node
    final availableChoices = _storyService.availableChoices();

    // Only show these panels if the player has logged in (password_entered == true)
    final bool isLoggedIn = flagService.getFlag('password_entered') == true;

    // Play sound effect when isLoggedIn transitions from false to true
    if (!_wasLoggedIn && isLoggedIn) {
      _wasLoggedIn = true;
      _sfxPlayer.play(AssetSource('audio/sfx/welcome_captain.mp3'));
      // Start flicker for background panel
      _startBackgroundFlicker();
    } else if (!isLoggedIn) {
      _wasLoggedIn = false;
      _showBackgroundPanel = false;
      _backgroundFlicker = false;
      _flickerCount = 0;
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedConstellationBackground(),

            // HEADER (fixed at the top)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('spacewalker'),
                      AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText('Login: ${widget.playerName}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /* SYSTEM LOG PANEL */
            CustomContainer(
              title: 'System Log',
              initialY: 50,
              initialX: MediaQuery.of(context).size.width - 670,
              minWidth: 100,
              minHeight: 200,
              padding: const EdgeInsets.all(10.0),
              child: SystemLogWidget(
                logs: systemLogList,
                playerName: widget.playerName,
              ),
            ),

            // Dialogue Panel (always visible)
            CustomContainer(
              padding: const EdgeInsets.all(5.0),
              title: 'Comms',
              initialY: 50,
              initialX: MediaQuery.of(context).size.width - 370,
              minWidth: 350,
              minHeight: MediaQuery.of(context).size.height - 100,
              child:
                  (_dialogueIndex < dialogues.length)
                      ? DialogueWidget(
                        dialogueHistory: dialogueHistory,
                        onNext: _nextDialogue,
                        isLastLine: isLastLine,
                        playerName: widget.playerName,
                        choices: isLastLine ? availableChoices : [],
                        onChoiceSelected: _onChoiceSelected,
                        characterMap: _storyService.characterMap,
                      )
                      : const SizedBox.shrink(),
            ),

            // All other panels only if logged in
            if (isLoggedIn && _showBackgroundPanel) ...[
              /* STATUS PANEL */
              CustomContainer(
                padding: const EdgeInsets.all(10.0),
                title: 'Status',
                initialY: 350,
                initialX: 50,
                minWidth: 200,
                minHeight: 200,
                child: SizedBox(
                  width: 260, // or whatever fits your UI
                  height: 200,
                  child: Column(
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'NUR 10',
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                        repeatForever: true,
                      ),
                      Text(
                        'Crew Morale: ${_storyService.morale}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text('Number of Crew: ${_storyService.crew}'),
                      Text('Number of passengers: ${_storyService.passengers}'),
                      Text('Fuel status: ${_storyService.fuel}%'),
                    ],
                  ),
                ),
              ),

              /* MUSIC PLAYER PANEL */
              CustomContainer(
                padding: const EdgeInsets.all(10.0),
                title: 'Music Player',
                initialY: 50,
                initialX: 50,
                minHeight: 230,
                minWidth: 350,
                child: MusicPlaylist(
                  onPlay: (assetPath) async {
                    await _playlistPlayer.stop();
                    await _playlistPlayer.play(AssetSource(assetPath));
                  },
                  onPause: () async {
                    await _playlistPlayer.pause();
                  },
                  player: _playlistPlayer,
                ),
              ),
            ],

            // PUZZLE PANEL (should be visible even if not logged in, when active)
            if (_activePuzzle != null)
              CustomContainer(
                padding: const EdgeInsets.all(10.0),
                title: 'Puzzle',
                initialY: 50,
                initialX: 300,
                minWidth: 500,
                minHeight: 530,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PuzzleWidget(
                      puzzle: _activePuzzle!,
                      onSubmit: _onPuzzleSubmit,
                      errorMessage: _puzzleErrorMessage,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activePuzzle = null;
                          _puzzleErrorMessage = null;
                        });
                      },
                      child: const Text('Close Puzzle'),
                    ),
                  ],
                ),
              ),

            // Error overlay
            if (_showPuzzleWarning)
              ErrorOverlay(
                errorMessage: _puzzleErrorMessage ?? "An error occurred",
              ),

            /* BG IMAGE PANEL */
            // This panel will display each scene background
            if (_showBackgroundPanel &&
                isLoggedIn &&
                currentNode?.background != null &&
                currentNode!.background.isNotEmpty)
              CustomContainer(
                title: 'Window',
                initialY: 100,
                initialX: 700,
                minWidth: 300,
                minHeight: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    currentNode!.background,
                    fit: BoxFit.cover,
                    width: 400,
                    height: 250,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Center(child: Text('Background not found')),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
