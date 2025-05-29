import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:space_walker/screens/name_input_screen.dart';
import 'package:space_walker/models/node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await flagService.init();

  // Register adapters
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(ChoiceAdapter());
  Hive.registerAdapter(DialogueLineAdapter());
  Hive.registerAdapter(PuzzleAdapter());

  runApp(SpaceWalker());
}

class SpaceWalker extends StatelessWidget {
  const SpaceWalker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Walker',
      theme: ThemeData(
        fontFamily: 'Electrolize',
        colorScheme: ColorScheme.dark(
          secondary: Color(0xFF18222A),
          primary: Color(0xFF9ED7D0),
          brightness: Brightness.dark,
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(
              Color(0xFF9ED7D0),
            ), // Text color
            side: WidgetStateProperty.all<BorderSide>(
              BorderSide(color: Color(0xFF9ED7D0), width: 1),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ), // Border color
            backgroundColor: WidgetStateProperty.all(
              Color(0xFF18222A),
            ), // Background color
          ),
        ),

        textTheme: TextTheme(titleLarge: const TextStyle(fontSize: 23)),
      ),

      debugShowCheckedModeBanner: false,
      home: const NameInputScreen(),
    );
  }
}
