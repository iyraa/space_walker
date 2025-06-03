import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_walker/services/flag_service.dart';
import 'package:space_walker/screens/start_game_screen.dart';
import 'package:space_walker/models/node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await flagService.init();
  await Hive.openBox('custom_container');

  // Register adapters
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(NodeContentAdapter());
  Hive.registerAdapter(CharacterAdapter());

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
          // secondary: Color(0xFF18222A),
          secondary: Color.fromRGBO(24, 34, 42, 1),
          //primary: Color(0xFF9ED7D0),
          primary: Color.fromRGBO(147, 217, 240, 1),
          brightness: Brightness.dark,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF9ED7D0)),
            side: WidgetStateProperty.all<BorderSide>(
              BorderSide(color: Color.fromRGBO(147, 217, 240, 1), width: 1),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            backgroundColor: WidgetStateProperty.all(Color(0xFF18222A)),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
            side: WidgetStateProperty.all(
              const BorderSide(
                color: Color.fromRGBO(147, 217, 240, 1),
                width: 1,
              ), // Set border color and width
            ),
          ),
        ),
        textTheme: TextTheme(titleLarge: const TextStyle(fontSize: 23)).apply(
          bodyColor: const Color.fromRGBO(147, 217, 240, 1),
          displayColor: const Color.fromRGBO(147, 217, 240, 1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const StartGameScreen(),
    );
  }
}
