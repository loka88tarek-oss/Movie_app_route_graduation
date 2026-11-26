import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/clear_profile_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ClearProfileUseCase clearProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.clearProfileUseCase,
  }) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileData>(_onUpdateProfileData);
    on<ClearProfile>(_onClearProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await getProfileUseCase(event.uid);

    await result.fold(
      (failure) async {
        // If not cached yet, create default profile entity
        final defaultProfile = ProfileEntity(
          uid: event.uid,
          displayName: event.displayName ?? '',
          email: event.email ?? '',
          phone: '',
          avatarKey: 'avatar_1',
          wishlistCount: 0,
          historyCount: 0,
        );
        // Persist default
        await updateProfileUseCase(defaultProfile);
        emit(ProfileLoaded(profile: defaultProfile));
      },
      (profile) async {
        emit(ProfileLoaded(profile: profile));
      },
    );
  }

  Future<void> _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded || currentState is ProfileUpdatedSuccess) {
      final currentProfile = currentState is ProfileLoaded
          ? currentState.profile
          : (currentState as ProfileUpdatedSuccess).profile;

      final updated = currentProfile.copyWith(
        displayName: event.displayName,
        phone: event.phone,
        avatarKey: event.avatarKey,
      );

      emit(const ProfileLoading());
      final result = await updateProfileUseCase(updated);

      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (_) => emit(ProfileUpdatedSuccess(profile: updated)),
      );
    }
  }

  Future<void> _onClearProfile(
    ClearProfile event,
    Emitter<ProfileState> emit,
  ) async {
    await clearProfileUseCase();
    emit(const ProfileInitial());
  }
}
