import 'package:dartz/dartz.dart';
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/repositories/entity_repository.dart';

import '../../../../core/network/network_info.dart';

class JokeRepository implements EntityRepository {
  final JokeLocalDataSource localDataSource;
  final JokeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const JokeRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<JokeModel>>> getListOfRandomEntities() async {
    return await _getJokes(() => remoteDataSource.getJokes());
  }

  @override
  Future<Either<Failure, List<JokeModel>>> searchEntitiesByCategory(
      String query) async {
    return await _getJokes(() => remoteDataSource.searchJokes(query));
  }

  Future<Either<Failure, List<JokeModel>>> _getJokes(
      Future<List<JokeModel>> Function() getJokes) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteJokes = await getJokes();
        localDataSource.jokesToCache(remoteJokes);
        return Right(remoteJokes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localJokes = await localDataSource.getLastJokesFromCache();
        return Right(localJokes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
