import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class PreferencesService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(AppConstants.themeKey, mode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConstants.themeKey) ?? 'light'; //system
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(AppConstants.onboardingCompletedKey, true);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  Future<void> setLastGameCategory(String category) async {
    await _prefs.setString('last_game_category', category);
  }

  String? getLastGameCategory() {
    return _prefs.getString('last_game_category');
  }

  Future<void> setLastGameTypeId(String gameId) async {
    await _prefs.setString('last_game_type_id', gameId);
  }

  String? getLastGameTypeId() {
    return _prefs.getString('last_game_type_id');
  }

  Future<void> clearUserData() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key != AppConstants.themeKey &&
          key != AppConstants.onboardingCompletedKey) {
        await _prefs.remove(key);
      }
    }
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
