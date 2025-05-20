import 'package:flutter/material.dart';
import 'package:space_walker/screens/game_screen.dart';
import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  String _playerName = '';
  bool showNameSection = false;
  bool _isLoading = false;

  void _showNameInput() {
    setState(() {
      showNameSection = true;
    });
  }

  Future<void> _startGame() async {
    String playerName = _controller.text.trim();
    if (playerName.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Play SFX and wait for it to finish (or wait a fixed duration)
      final player = AudioPlayer();
      await player.play(AssetSource('assets/audio/sfx/welcome_captain.w4a'));
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      playerName =
          playerName[0].toUpperCase() + playerName.substring(1).toLowerCase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(playerName: 'Captain $playerName'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _playerName = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('background/space_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AnimatedBackground(
              behaviour: SpaceBehaviour(),
              vsync: this,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Space Walker',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _playerName.isEmpty
                            ? ''
                            : 'Welcome Captain ${_playerName[0].toUpperCase()}${_playerName.length > 1 ? _playerName.substring(1) : ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: _showNameInput,
                        child: const Text('Start Game'),
                      ),
                      const SizedBox(height: 24),
                      if (showNameSection) ...[
                        const Text('Please enter your name'),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _isLoading ? null : _startGame,
                          child: const Text('Go on a mission'),
                        ),
                        const SizedBox(height: 24),
                      ],
                      OutlinedButton(
                        onPressed: () {
                          // Add your logic for this button
                        },
                        child: const Text('Settings'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Add your logic for this button
                        },
                        child: const Text('Playlist'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Add your logic for this button
                        },
                        child: const Text('Credits'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text(
                      'Welcome aboard, $_playerName',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
