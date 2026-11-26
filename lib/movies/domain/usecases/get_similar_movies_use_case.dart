import '../entities/movie_entity.dart';
import '../repo/movie_repo_abstract.dart';

class GetSimilarMoviesUseCase {
  final MovieRepoAbstract repo;

  GetSimilarMoviesUseCase(this.repo);

  Future<List<MovieEntity>> call({required int id}) {
    return repo.getSimilarMovies(id: id);
  }
}
