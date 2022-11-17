import 'dart:convert';

import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/parsers/json_parser.dart';

const cachedJokesList = 'CACHED_JOKES_LIST';

class JokeLocalDataSourceFromSharedPrefs implements JokeLocalDataSource {
  final SharedPreferences sharedPreferences;
  final JsonParser<JokeModel> parser;

  const JokeLocalDataSourceFromSharedPrefs({
    required this.sharedPreferences,
    required this.parser,
  });

  @override
  Future<List<JokeModel>> getLastJokesFromCache() {
    final jsonJokesList = sharedPreferences.getStringList(cachedJokesList);
    if (jsonJokesList?.isNotEmpty ?? false) {
      return Future.value(jsonJokesList!
          .map((joke) => parser.fromJson(json.decode(joke)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> jokesToCache(List<JokeModel> jokes) {
    final List<String> jsonJokesList =
      jokes.map((joke) => json.encode(parser.toJson(joke))).toList();
    sharedPreferences.setStringList(cachedJokesList, jsonJokesList);
    return Future.value();
  }
}
