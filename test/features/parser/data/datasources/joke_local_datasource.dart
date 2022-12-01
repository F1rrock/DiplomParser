import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/core/parsers/json_parser.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/local_datasources/joke_local_datasource_from_shared_prefs.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_attributes_mapper.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_mapper.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late JokeLocalDataSource dataSource;
  late MockSharedPreferences mockSharedPreferences;
  late JsonParser<ObjectEntity> jokeMapper;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    jokeMapper = const JokeMapper(
      attributesMapper: JokeAttributesMapper(),
    );
    dataSource = JokeLocalDataSourceFromSharedPrefs(
      sharedPreferences: mockSharedPreferences,
      parser: jokeMapper,
    );
  });

  group('getLastJokes', () {
    final testJokeModelList = jokeMapper.fromJson(
      json.decode(
        fixture('request.json'),
      ),
    );

    test(
      'should return List of Jokes from SharedPreferences when there is one in cache',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('request.json'));
        // act
        final result = await dataSource.getLastJokesFromCache();
        //assert
        verify(() => mockSharedPreferences.getString(cachedJokesList));
        expect(result, equals(testJokeModelList));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // act
        final call = dataSource.getLastJokesFromCache;
        //assert
        expect(
          () async => await call(),
          throwsA(
            const TypeMatcher<CacheException>(),
          ),
        );
      },
    );
  });

  group('cacheJokes', () {
    const jokeAttributesModel = JokeAttributesModel(
      nsfw: true,
      religious: false,
      political: false,
      racist: false,
      sexist: false,
      explicit: true,
    );
    const testJokeModel = JokeModel(
      category: "Misc",
      setup: "What do you call a bird sitting with their legs spread?",
      delivery: "A prostitweety.",
      flags: jokeAttributesModel,
      id: 224,
    );
    final testList = List<JokeModel>.filled(1, testJokeModel);

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.jokesToCache(testList);
        // assert
        final expectedJsonString =
            json.encode(jokeMapper.toJson(testJokeModel));
        verify(() => mockSharedPreferences.setString(
              cachedJokesList,
              expectedJsonString,
            ));
      },
    );
  });
}
