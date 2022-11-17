import '../models/joke_model.dart';

abstract class JokeRemoteDataSource {
  Future<List<JokeModel>> getJokes();
  Future<List<JokeModel>> searchJokes(String query);
}