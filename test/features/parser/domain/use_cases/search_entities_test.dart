import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';
import 'package:practise_parser/features/parser/domain/repositories/entity_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities.dart';

class MockEntityRepository extends Mock implements EntityRepository {}

void main() {
  late SearchEntities useCase;
  late MockEntityRepository mockRepository;

  setUp(() {
    mockRepository = MockEntityRepository();
    useCase = SearchEntities(repository: mockRepository);
  });

  const testCategory = 'test category';
  const testEntity = ObjectEntity(
    id: 1,
    name: 'test name',
    category: 'test category',
    description: 'test description',
    attributes: AttributesEntity(),
  );
  final testList = List<ObjectEntity>.filled(1, testEntity);

  const testFailure = ServerFailure();

  group(
    'test returns value from SearchEntities use case',
    () {
      test(
        'should get entity from the repository',
            () async {
          // arrange
          when(() => mockRepository.searchEntities(any()))
              .thenAnswer((_) async => Right(testList));
          // act
          final result = await useCase(
            const Params(
              query: testCategory,
            ),
          );
          // assert
          expect(
            result,
            Right(testList),
          );
          verify(() {
            mockRepository.searchEntities(
              testCategory,
            );
          });
          verifyNoMoreInteractions(mockRepository);
        },
      );

      test(
        'should get failure from the repository',
            () async {
          // arrange
          when(() => mockRepository.searchEntities(any()))
              .thenAnswer((_) async => const Left(ServerFailure()));
          // act
          final result = await useCase(
            const Params(
              query: testCategory,
            ),
          );
          // assert
          expect(
            result,
            const Left(testFailure),
          );
          verify(() {
            mockRepository.searchEntities(
              testCategory,
            );
          });
          verifyNoMoreInteractions(mockRepository);
        },
      );
    },
  );
}
