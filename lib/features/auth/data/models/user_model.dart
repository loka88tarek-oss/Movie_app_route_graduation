import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoURL,
    super.emailVerified,
  });

  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  UserEntity toEntity() => UserEntity(
    uid: uid,
    email: email,
    displayName: displayName,
    photoURL: photoURL,
    emailVerified: emailVerified,
  );
}
