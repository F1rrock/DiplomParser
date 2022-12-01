import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practise_parser/core/error/exceptions.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/core/network/network_info.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/data/repositories/joke_repository.dart';
import 'package:practise_parser/features/parser/domain/repositories/entity_repository.dart';

class MockRemoteDataSource extends Mock implements JokeRemoteDataSource {}

class MockLocalDataSource extends Mock implements JokeLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late EntityRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = JokeRepository(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('search jokes', () {
    const testCategory = 'Misc';
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
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.searchJokes(any()))
            .thenAnswer((_) async => testList);
        when(() => mockLocalDataSource.jokesToCache(any()))
            .thenAnswer((_) async => Future.value());
        // act
        repository.searchEntities(testCategory);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.searchJokes(any()))
              .thenAnswer((_) async => testList);
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.searchEntities(testCategory);
          // assert
          verify(() => mockRemoteDataSource.searchJokes(testCategory));
          expect(result, equals(Right(testList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.searchJokes(any()))
              .thenAnswer((_) async => testList);
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          await repository.searchEntities(testCategory);
          // assert
          verify(() => mockRemoteDataSource.searchJokes(testCategory));
          verify(() => mockLocalDataSource.jokesToCache(testList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.searchJokes(any()))
              .thenThrow(ServerException());
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.searchEntities(testCategory);
          // assert
          verify(() => mockRemoteDataSource.searchJokes(testCategory));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastJokesFromCache())
              .thenAnswer((_) async => testList);
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.searchEntities(testCategory);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastJokesFromCache());
          expect(result, equals(Right(testList)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastJokesFromCache())
              .thenThrow(CacheException());
          // act
          final result = await repository.searchEntities(testCategory);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastJokesFromCache());
          expect(result, equals(const Left(CacheFailure())));
        },
      );
    });
  });

  group('get random jokes', () {
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
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getJokes())
            .thenAnswer((_) async => testList);
        when(() => mockLocalDataSource.jokesToCache(any()))
            .thenAnswer((_) async => Future.value());
        // act
        repository.getListOfRandomEntities();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getJokes())
              .thenAnswer((_) async => testList);
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getListOfRandomEntities();
          // assert
          verify(() => mockRemoteDataSource.getJokes());
          expect(result, equals(Right(testList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getJokes())
              .thenAnswer((_) async => testList);
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          await repository.getListOfRandomEntities();
          // assert
          verify(() => mockRemoteDataSource.getJokes());
          verify(() => mockLocalDataSource.jokesToCache(testList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getJokes())
              .thenThrow(ServerException());
          when(() => mockLocalDataSource.jokesToCache(any()))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getListOfRandomEntities();
          // assert
          verify(() => mockRemoteDataSource.getJokes());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastJokesFromCache())
              .thenAnswer((_) async => testList);
          // act
          final result = await repository.getListOfRandomEntities();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastJokesFromCache());
          expect(result, equals(Right(testList)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastJokesFromCache())
              .thenThrow(CacheException());
          // act
          final result = await repository.getListOfRandomEntities();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastJokesFromCache());
          expect(result, equals(const Left(CacheFailure())));
        },
      );
    });
  });
}
