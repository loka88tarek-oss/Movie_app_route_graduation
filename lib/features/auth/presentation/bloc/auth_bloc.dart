import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_auth_state_stream_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetAuthStateStreamUseCase getAuthStateStreamUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final SharedPrefsHelper sharedPrefsHelper;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.forgotPasswordUseCase,
    required this.updateProfileUseCase,
    required this.getCurrentUserUseCase,
    required this.getAuthStateStreamUseCase,
    required this.signInWithGoogleUseCase,
    required this.deleteAccountUseCase,
    required this.sharedPrefsHelper,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    _authSubscription?.cancel();
    _authSubscription = getAuthStateStreamUseCase().listen((user) {
      add(AuthUserChanged(user));
    });

    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (_) => emit(const Unauthenticated()),
      (user) => user != null
          ? emit(Authenticated(user: user))
          : emit(const Unauthenticated()),
    );
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(user: event.user!));
    } else {
      emit(const Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await signInUseCase(SignInParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await signUpUseCase(SignUpParams(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    ));
    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (user) async {
        await sharedPrefsHelper.saveUserPhone(event.phone);
        if (event.avatarKey != null) {
          await sharedPrefsHelper.saveUserAvatar(event.avatarKey!);
        }
        emit(Authenticated(user: user));
      },
    );
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await forgotPasswordUseCase(ForgotPasswordParams(email: event.email));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const PasswordResetSent()),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await signInWithGoogleUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await updateProfileUseCase(UpdateProfileParams(
      displayName: event.displayName,
      photoURL: event.photoURL,
    ));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(ProfileUpdated(user: user)),
    );
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await deleteAccountUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
