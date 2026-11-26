import 'dart:convert';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.uid,
    required super.displayName,
    required super.email,
    required super.phone,
    required super.avatarKey,
    required super.wishlistCount,
    required super.historyCount,
  });

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      uid: entity.uid,
      displayName: entity.displayName,
      email: entity.email,
      phone: entity.phone,
      avatarKey: entity.avatarKey,
      wishlistCount: entity.wishlistCount,
      historyCount: entity.historyCount,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarKey: json['avatarKey'] as String? ?? 'avatar_1',
      wishlistCount: json['wishlistCount'] as int? ?? 0,
      historyCount: json['historyCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'avatarKey': avatarKey,
      'wishlistCount': wishlistCount,
      'historyCount': historyCount,
    };
  }

  factory ProfileModel.fromJsonString(String jsonString) {
    return ProfileModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );
  }

  String toJsonString() => json.encode(toJson());

  ProfileModel copyWithModel({
    String? uid,
    String? displayName,
    String? email,
    String? phone,
    String? avatarKey,
    int? wishlistCount,
    int? historyCount,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarKey: avatarKey ?? this.avatarKey,
      wishlistCount: wishlistCount ?? this.wishlistCount,
      historyCount: historyCount ?? this.historyCount,
    );
  }
}
