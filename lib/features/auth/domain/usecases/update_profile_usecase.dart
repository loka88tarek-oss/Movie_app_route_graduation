import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase extends UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      displayName: params.displayName,
      photoURL: params.photoURL,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? displayName;
  final String? photoURL;
  const UpdateProfileParams({this.displayName, this.photoURL});

  @override
  List<Object?> get props => [displayName, photoURL];
}
