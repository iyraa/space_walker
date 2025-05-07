import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:space_walker/services/story_service.dart';

import 'models/node.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Register adapters
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(ChoiceAdapter());
  final nodeBox = await Hive.openBox<Node>('nodeBox');
  if (nodeBox.isEmpty) {
    print('loading story from JSON...');
    await loadStoryFromJson(); //load the story data into Hive if box is empty
    print('story loaded into Hive');
  }
  // Open the story data and start the app
  // await Hive.deleteBoxFromDisk('nodeBox');
  // var nodeBox = await Hive.openBox<Node>('nodeBox');
  //await Hive.openBox<Node>('nodeBox');

  runApp(SpaceWalker());
}

class SpaceWalker extends StatelessWidget {
  const SpaceWalker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Walker',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: NameInputScreen(),
    );
  }
}

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _controller = TextEditingController();

  void _startGame() {
    var name = _controller.text.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1).toLowerCase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(playerName: 'Captain $name'),
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
              Text('Enter your name:', style: TextStyle(fontSize: 20)),
              SizedBox(height: 12),
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _startGame, child: Text('Start Mission')),
            ],
          ),
        ),
      ),
    );
  }
}
