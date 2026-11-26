import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile(String uid);
  Future<void> saveProfile(ProfileModel profile);
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  String _getKey(String uid) => 'profile_$uid';

  @override
  Future<ProfileModel> getProfile(String uid) async {
    final jsonString = sharedPreferences.getString(_getKey(uid));
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        return ProfileModel.fromJsonString(jsonString);
      } catch (e) {
        throw CacheException(message: 'Failed to parse cached profile: $e');
      }
    } else {
      throw const CacheException(message: 'No cached profile found');
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    try {
      await sharedPreferences.setString(
        _getKey(profile.uid),
        profile.toJsonString(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save profile locally: $e');
    }
  }

  @override
  Future<void> clearProfile() async {
    try {
      final keys = sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.startsWith('profile_')) {
          await sharedPreferences.remove(key);
        }
      }
    } catch (e) {
      throw CacheException(message: 'Failed to clear local profile: $e');
    }
  }
}
