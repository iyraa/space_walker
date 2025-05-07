import 'package:flutter/material.dart';
import 'package:space_walker/screens/game_screen.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _controller = TextEditingController();

  void _startGame() {
    String playerName = _controller.text.trim();
    if (playerName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => GameScreen(playerName: '(Captain + $playerName)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your name'),
              TextField(controller: _controller),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Go on a mission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
