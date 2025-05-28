import 'package:flutter/material.dart';
import 'package:space_walker/screens/game_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:space_walker/ui/custom_container.dart';
import '../ui/constellation_background.dart'; // Add this import

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
      await player.play(AssetSource('audio/sfx/welcome_captain.mp3'));
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

                  // Center: Title, name, buttons
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
                              // AnimatedTextKit(
                              //   animatedTexts: [
                              //     FlickerAnimatedText(
                              //       'SPACE WALKER',
                              //       textStyle: TextStyle(
                              //         fontFamily: 'BrunoAceSC',
                              //         fontSize: 42,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ],
                              //   isRepeatingAnimation: true,
                              //   repeatForever: true,
                              // ),
                            ],
                          ),
                          // const SizedBox(height: 16),
                          // Text(
                          //   _playerName.isEmpty
                          //       ? 'Welc'
                          //       : 'Welcome Captain ${_playerName[0].toUpperCase()}${_playerName.length > 1 ? _playerName.substring(1) : ''}',
                          //   style: const TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.tealAccent,
                          //   ),
                          // ),
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

                              if (_playerName.isNotEmpty)
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
                                child: const Text('Settings'),
                              ),
                              const SizedBox(width: 12),
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
                  const SizedBox(width: 24),
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
