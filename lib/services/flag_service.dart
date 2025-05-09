import 'package:hive/hive.dart';

class FlagService {
  static const String _boxFlag = 'flagsBox';
  late Box _box;

  /// Initialize the Hive box (call once in `main()` before use)
  Future<void> init() async {
    _box = await Hive.openBox(_boxFlag);
  }

  /// Apply a map of flags to the box (e.g., from a Choice)
  void applyFlag(Map<String, int>? setFlag) {
    if (setFlag == null) return;

    setFlag.forEach((key, value) {
      final currentValue =
          _box.get(key, defaultValue: 0)
              as int; // default to 0 if the flag doesn't exist
      _box.put(
        key,
        currentValue + value,
      ); // Increment the existing value or set it
    });
  }

  /// Check if all given conditions are met (assuming they are integers now)
  bool areConditionsMet(Map<String, int> conditions) {
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
  int? getFlag(String key) {
    final value = _box.get(key);
    print('Getting flag value: $key => $value'); // Debugging flag retrieval
    return value;
  }

  /// Clear all flags (useful for restart or debug)
  Future<void> clearFlags() async {
    print("All flags cleared");
    await _box.clear();
  }

  /// Optional: check if a specific flag exists
  bool hasFlag(String key) {
    return _box.containsKey(key);
  }
}

final FlagService flagService = FlagService();
