import 'package:flutter/material.dart';
import 'package:space_walker/screens/game_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:space_walker/ui/constellation_background.dart';
import 'package:space_walker/ui/custom_container.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  final _controller = TextEditingController();
  String _playerName = '';
  bool _isLoading = false;

  Future<void> _startGame() async {
    final text = _controller.text.trim();
    _playerName =
        text.isNotEmpty
            ? text[0].toUpperCase() + text.substring(1).toLowerCase()
            : '';

    if (_playerName.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Play SFX and wait for it to finish (or wait a fixed duration)
      final player = AudioPlayer();
      await player.play(AssetSource('audio/sfx/welcome_captain.mp3'));
      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(playerName: 'Captain $_playerName'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: const AnimatedConstellationBackground(),
          ),
          Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left GIF
                  Image.asset("images/title.gif", fit: BoxFit.cover),
                  const SizedBox(width: 24),

                  // Right: Title, name, buttons
                  Expanded(
                    child: CustomContainer(
                      padding: EdgeInsets.fromLTRB(16, 100, 16, 100),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "images/siti.gif",
                                height: 80,

                                fit: BoxFit.cover,
                              ),

                              SizedBox(height: 20),
                              GlowText(
                                'SPACE',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 50.0,
                                  fontFamily: 'BrunoAceSC',
                                ),
                              ),
                              GlowText(
                                'WALKER',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 50.0,
                                  fontFamily: 'BrunoAceSC',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: [
                              const SizedBox(height: 16),

                              const Text('Please enter your name'),
                              SizedBox(
                                width: 180,
                                child: TextField(
                                  controller: _controller,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),

                              const SizedBox(height: 16),

                              //if (_playerName.isNotEmpty)
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: _startGame,
                                child: const Text('Go on a mission'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Playlist'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Credits'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CircularProgressIndicator(),
                    Image.asset(
                      "images/siti.gif",
                      height: 80,

                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Welcome, Captain $_playerName',
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
