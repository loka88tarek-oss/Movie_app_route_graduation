import '../entities/movie_entity.dart';
import '../repo/movie_repo_abstract.dart';

class GetMovieDetailsUseCase {
  final MovieRepoAbstract repo;

  GetMovieDetailsUseCase(this.repo);

  Future<MovieDetailsEntity> call({required int id}) {
    return repo.getMovieDetails(id: id);
  }
}
