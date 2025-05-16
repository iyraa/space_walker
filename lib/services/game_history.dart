import 'dart:convert';
import 'package:hive/hive.dart';

class GameHistory {
  static late Box gameHistoryBox;

  // Initialize the Hive box
  static Future<void> initGameHistory() async {
    gameHistoryBox = await Hive.openBox(
      'gameHistory',
    ); // Open a box to store game history
  }

  // Get the current scenario index
  static int getCurrentScenarioIndex() {
    return gameHistoryBox.get('currentScenarioIndex', defaultValue: 0);
  }

  // Save the game state (history and current scenario)
  static Future<void> saveGameHistory(String character, String story, String choice) async {
  // Retrieve the existing history (or an empty list if there is no history)
  List<Map<String, dynamic>> history = List.from(
    jsonDecode(gameHistoryBox.get('history', defaultValue: '[]') as String),
  );

  // Add the new story with character and choice information
  history.add({
    'character': character,
    'story': story,
    'choice': choice,
  });

  // Save the updated history back to the Hive box
  await gameHistoryBox.put('history', jsonEncode(history));
  // Optionally, you can also save the current scenario index if needed
  await gameHistoryBox.put('currentScenarioIndex', getCurrentScenarioIndex());
}

  // Clear the game history
  static Future<void> clearGameHistory() async {
    await gameHistoryBox.clear();
  }

  // Retrieve all the saved dialogue history
  static List<Map<String, dynamic>> getDialogueHistory() {
    return List<Map<String, dynamic>>.from(
      jsonDecode(gameHistoryBox.get('history', defaultValue: '[]') as String),
    );
  }
}
