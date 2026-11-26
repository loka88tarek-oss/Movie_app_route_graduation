import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();
  static SharedPrefsHelper? _instance;
  static SharedPreferences? _prefs;

  static Future<SharedPrefsHelper> getInstance() async {
    _instance ??= SharedPrefsHelper._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserAvatar = 'user_avatar';

  // Onboarding
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs!.setBool(_keyHasSeenOnboarding, value);
  }

  bool getHasSeenOnboarding() {
    return _prefs!.getBool(_keyHasSeenOnboarding) ?? false;
  }

  // User profile extras (non-Firebase fields)
  Future<void> saveUserPhone(String phone) async {
    await _prefs!.setString(_keyUserPhone, phone);
  }

  String getUserPhone() => _prefs!.getString(_keyUserPhone) ?? '';

  Future<void> saveUserAvatar(String avatarKey) async {
    await _prefs!.setString(_keyUserAvatar, avatarKey);
  }

  String getUserAvatar() => _prefs!.getString(_keyUserAvatar) ?? 'avatar_1';

  Future<void> saveUserId(String uid) async {
    await _prefs!.setString(_keyUserId, uid);
  }

  String getUserId() => _prefs!.getString(_keyUserId) ?? '';

  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}
