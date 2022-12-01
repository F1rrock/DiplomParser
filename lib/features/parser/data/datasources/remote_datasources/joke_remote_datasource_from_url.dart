import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/core/parsers/json_parser.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

class JokeRemoteDataSourceFromUrl implements JokeRemoteDataSource {
  final http.Client client;
  final JsonParser<ObjectEntity> parser;

  const JokeRemoteDataSourceFromUrl({
    required this.client,
    required this.parser,
  });

  /// throws [ServerException]
  /// calls the https://v2.jokeapi.dev/joke/Any?type=twopart&amount=10
  @override
  Future<List<ObjectEntity>> getJokes() => _getJokesFromUrl(
      'https://v2.jokeapi.dev/joke/Any?type=twopart&amount=10');

  /// calls the https://v2.jokeapi.dev/joke/{category}?type=twopart&amount=10
  @override
  Future<List<ObjectEntity>> searchJokes(String query) => _getJokesFromUrl(
      'https://v2.jokeapi.dev/joke/$query?type=twopart&amount=10');

  Future<List<ObjectEntity>> _getJokesFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    final responseMessage = json.decode(response.body);
    if (response.statusCode == 200 && responseMessage['error'] == false) {
      return (responseMessage['jokes'] as List)
          .map((joke) => parser.fromJson(joke))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
