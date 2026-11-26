import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(ProfileEntity profile) {
    return repository.saveProfile(profile);
  }
}
