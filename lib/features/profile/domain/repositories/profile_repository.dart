import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String uid);
  Future<Either<Failure, void>> saveProfile(ProfileEntity profile);
  Future<Either<Failure, void>> clearProfile();
}
