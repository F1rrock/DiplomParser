import 'package:practise_parser/features/parser/data/models/joke_model.dart';

abstract class JokeLocalDataSource {
  Future<List<JokeModel>> getLastJokesFromCache();
  Future<void> jokesToCache(List<JokeModel> jokes);
}