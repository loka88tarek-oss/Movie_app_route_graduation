part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final String phone;
  final String? avatarKey;
  const SignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
    required this.phone,
    this.avatarKey,
  });

  @override
  List<Object?> get props => [email, password, displayName, phone, avatarKey];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class UpdateProfileRequested extends AuthEvent {
  final String? displayName;
  final String? photoURL;
  const UpdateProfileRequested({this.displayName, this.photoURL});

  @override
  List<Object?> get props => [displayName, photoURL];
}

class DeleteAccountRequested extends AuthEvent {
  const DeleteAccountRequested();
}
