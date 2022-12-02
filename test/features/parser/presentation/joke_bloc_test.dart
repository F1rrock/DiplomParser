import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/core/util/input_checker.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_entities.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities.dart';
import 'package:practise_parser/features/parser/presentation/ploc/bloc.dart';

class MockSearchEntities extends Mock implements SearchEntities {}

class MockGetListOfRandomEntities extends Mock implements GetListOfEntities {}

class MockInputChecker extends Mock implements InputChecker {}

class FakeParams extends Fake implements Params {}

void main() {
  late EntityBloc bloc;
  late GetListOfEntities mockGetListOfEntities;
  late SearchEntities mockSearchEntities;
  late InputChecker mockInputChecker;

  setUp(() {
    registerFallbackValue(FakeParams());
    mockGetListOfEntities = MockGetListOfRandomEntities();
    mockSearchEntities = MockSearchEntities();
    mockInputChecker = MockInputChecker();
    bloc = EntityBloc(
      getEntities: mockGetListOfEntities,
      searchEntities: mockSearchEntities,
      inputChecker: mockInputChecker,
    );
  });

  test(
    'initialize should be Empty',
    () {
      // assert
      expect(bloc.state, equals(const EmptyState()));
    },
  );

  group(
    'search entities',
    () {
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

      void setUpMockInputCheckerSuccess() => when(() =>
              mockInputChecker.checkIsStringWithoutSpecialCharacters(any()))
          .thenReturn(const Right(testCategory));

      test(
        'should call the InputChecker to validate',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
          await untilCalled(() =>
              mockInputChecker.checkIsStringWithoutSpecialCharacters(any()));
          // assert
          verify(() => mockInputChecker
              .checkIsStringWithoutSpecialCharacters(testCategory));
        },
      );

      test(
        'should emit [Error] when the input is invalid',
        () async* {
          // arrange
          when(() =>
                  mockInputChecker.checkIsStringWithoutSpecialCharacters(any()))
              .thenReturn(const Left(InvalidInputFailure()));
          // assert later
          const expected = [
            EmptyState(),
            ErrorState(message: inputFailureMessage),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
        },
      );

      test(
        'should get correct last query',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          when(() => mockSearchEntities(any()))
              .thenAnswer((_) async => Right(testList));
          // act
          bloc.execute(const GetListOfEntitiesEvent());
          await untilCalled(() => mockSearchEntities(any()));
          // assert
          verify(() => mockSearchEntities(const Params(query: testCategory)));
          expect(bloc.lastQuery, equals(const GetListOfEntitiesEvent()));
        },
      );

      test(
        'should get data from concrete use case',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          when(() => mockSearchEntities(any()))
              .thenAnswer((_) async => Right(testList));
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
          await untilCalled(() => mockSearchEntities(any()));
          // assert
          verify(() => mockSearchEntities(const Params(query: testCategory)));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          when(() => mockSearchEntities(any()))
              .thenAnswer((_) async => Right(testList));
          // assert later
          final expected = [
            const EmptyState(),
            const LoadingState(),
            LoadedState(
              entities: testList,
            ),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          when(() => mockSearchEntities(any()))
              .thenAnswer((_) async => const Left(ServerFailure()));
          // assert later
          const expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: serverFailureMessage),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
          // arrange
          setUpMockInputCheckerSuccess();
          when(() => mockSearchEntities(any()))
              .thenAnswer((_) async => const Left(CacheFailure()));
          // assert later
          const expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: cacheFailureMessage),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const SearchEntitiesEvent(query: testCategory));
        },
      );
    },
  );

  group(
    'get random entities',
    () {
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
        'should get data from concrete use case',
        () async {
          // arrange
          when(() => mockGetListOfEntities(const NoParams()))
              .thenAnswer((_) async => Right(testList));
          // act
          bloc.add(const GetListOfEntitiesEvent());
          await untilCalled(() => mockGetListOfEntities(const NoParams()));
          // assert
          verify(() => mockGetListOfEntities(const NoParams()));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async* {
          // arrange
          when(() => mockGetListOfEntities(const NoParams()))
              .thenAnswer((_) async => Right(testList));
          // assert later
          final expected = [
            const EmptyState(),
            const LoadingState(),
            LoadedState(
              entities: testList,
            ),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const GetListOfEntitiesEvent());
        },
      );

      test(
        'should emit [Loading, Error] when getting data fails',
        () async* {
          // arrange
          when(() => mockGetListOfEntities(const NoParams()))
              .thenAnswer((_) async => const Left(ServerFailure()));
          // assert later
          const expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: serverFailureMessage),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const GetListOfEntitiesEvent());
        },
      );

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
          // arrange
          when(() => mockGetListOfEntities(const NoParams()))
              .thenAnswer((_) async => const Left(CacheFailure()));
          // assert later
          const expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: cacheFailureMessage),
          ];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(const GetListOfEntitiesEvent());
        },
      );
    },
  );
}
