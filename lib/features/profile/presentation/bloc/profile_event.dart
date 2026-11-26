import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String uid;
  final String? email;
  final String? displayName;

  const LoadProfile({
    required this.uid,
    this.email,
    this.displayName,
  });

  @override
  List<Object?> get props => [uid, email, displayName];
}

class UpdateProfileData extends ProfileEvent {
  final String displayName;
  final String phone;
  final String avatarKey;

  const UpdateProfileData({
    required this.displayName,
    required this.phone,
    required this.avatarKey,
  });

  @override
  List<Object?> get props => [displayName, phone, avatarKey];
}

class ClearProfile extends ProfileEvent {
  const ClearProfile();
}
