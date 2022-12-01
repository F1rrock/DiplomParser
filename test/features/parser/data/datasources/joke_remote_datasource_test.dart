import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/remote_datasources/joke_remote_datasource_from_url.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_attributes_mapper.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_mapper.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late JokeRemoteDataSource dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    registerFallbackValue(FakeUri());
    mockHttpClient = MockHttpClient();
    dataSource = JokeRemoteDataSourceFromUrl(
      client: mockHttpClient,
      parser: const JokeMapper(
        attributesMapper: JokeAttributesMapper(),
      ),
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('request.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('error.json'), 404),
    );
  }

  group('search jokes', () {
    const testCategory = 'Misc';
    const jokeMapper = JokeMapper(
      attributesMapper: JokeAttributesMapper(),
    );
    final testJokeModelList =
        ((json.decode(fixture('request.json'))['jokes'] ?? []) as List)
            .map((joke) => jokeMapper.fromJson(joke))
            .toList();

    test(
      '''should perform a GET request on a URL''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        //act
        dataSource.searchJokes(testCategory);
        //assert
        verify(
          () => mockHttpClient.get(
            Uri.parse(
              'https://v2.jokeapi.dev/joke/$testCategory?type=twopart&amount=10',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return List of Jokes when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.searchJokes(testCategory);
        // assert
        expect(result, equals(testJokeModelList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.searchJokes;
        // assert
        expect(
          () => call('some'),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });

  group('get jokes', () {
    const jokeMapper = JokeMapper(
      attributesMapper: JokeAttributesMapper(),
    );
    final testJokeModelList =
    ((json.decode(fixture('request.json'))['jokes'] ?? []) as List)
        .map((joke) => jokeMapper.fromJson(joke))
        .toList();

    test(
      '''should perform a GET request on a URL with jokes being the endpoint 
      and with application/json header''',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        //act
        dataSource.getJokes();
        //assert
        verify(
              () => mockHttpClient.get(
            Uri.parse(
              'https://v2.jokeapi.dev/joke/Any?type=twopart&amount=10',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return List of Jokes when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getJokes();
        // assert
        expect(result, equals(testJokeModelList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getJokes;
        // assert
        expect(
              () => call(),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
