import 'package:practise_parser/features/parser/domain/entities/entity.dart';

abstract class JokeLocalDataSource {
  Future<List<ObjectEntity>> getLastJokesFromCache();
  Future<void> jokesToCache(List<ObjectEntity> jokes);
}