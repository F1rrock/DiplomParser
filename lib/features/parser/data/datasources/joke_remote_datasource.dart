import '../../domain/entities/entity.dart';

abstract class JokeRemoteDataSource {
  Future<List<ObjectEntity>> getJokes();
  Future<List<ObjectEntity>> searchJokes(String query);
}