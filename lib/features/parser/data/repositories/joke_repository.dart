import 'package:dartz/dartz.dart';
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';
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
  Future<Either<Failure, List<ObjectEntity>>> getListOfRandomEntities() async {
    return await _getJokes(() => remoteDataSource.getJokes());
  }

  @override
  Future<Either<Failure, List<ObjectEntity>>> searchEntities(
      String query) async {
    await networkInfo.isConnected;
    return await _getJokes(() => remoteDataSource.searchJokes(query));
    // return null;
  }

  Future<Either<Failure, List<ObjectEntity>>> _getJokes(
      Future<List<ObjectEntity>> Function() getJokes) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteJokes = await getJokes();
        localDataSource.jokesToCache(remoteJokes);
        return Right(remoteJokes);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localJokes = await localDataSource.getLastJokesFromCache();
        return Right(localJokes);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }
}
