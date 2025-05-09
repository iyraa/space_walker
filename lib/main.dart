import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:space_walker/services/story_service.dart';
import 'package:space_walker/screens/name_input_screen.dart';
import 'models/node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  //final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter();
  await flagService.init();

  // Register adapters
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(ChoiceAdapter());
  Hive.registerAdapter(DialogueLineAdapter());

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
      home: const NameInputScreen(),
    );
  }
}
