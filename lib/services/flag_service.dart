import 'package:hive/hive.dart';

class FlagService {
  static const String _boxFlag = 'flagsBox';
  late Box _box;

  // Initialize the Hive box (call once in `main()` before use)
  // Help to reset the flags box when restart
  Future<void> init() async {
    _box = await Hive.openBox('flags');
  }

  /// Apply a map of flags to the box (e.g., from a Choice)
  void applyFlag(Map<String, bool>? setFlag) {
    if (setFlag == null) return;

    setFlag.forEach((key, value) {
      _box.put(key, value);
    });
  }

  // Check if all given conditions are met
  bool areConditionsMet(Map<String, bool> conditions) {
    for (var entry in conditions.entries) {
      final flagValue = getFlag(entry.key);

      final conditionValue = entry.value;

      if (flagValue == null) {
        return false; // Condition fails if flag is not found
      }

      if (flagValue != conditionValue) {
        return false; // Condition fails if the flag value doesn't match
      }
    }
    return true;
  }

  /// Retrieve the current value of a flag
  bool? getFlag(String key) {
    final value = _box.get(key);
    //print('Getting flag value: $key => $value'); // Debugging flag retrieval
    if (value is bool) return value;
    return null;
  }

  // Clear all flags
  Future<void> clearFlags() async {
    print("All flags cleared");
    await _box.clear();
  }

  // Optional: check if a specific flag exists
  bool hasFlag(String key) {
    return _box.containsKey(key);
  }
}

final FlagService flagService = FlagService();
