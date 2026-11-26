import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static const _lastGenreKey = 'last_browse_genre';

  String? get lastBrowseGenre => _prefs.getString(_lastGenreKey);

  Future<void> saveLastBrowseGenre(String genre) {
    return _prefs.setString(_lastGenreKey, genre);
  }

  Future<void> clearLastBrowseGenre() {
    return _prefs.remove(_lastGenreKey);
  }
}