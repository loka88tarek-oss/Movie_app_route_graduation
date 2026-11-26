import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class ClearProfileUseCase {
  final ProfileRepository repository;
  const ClearProfileUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearProfile();
  }
}
