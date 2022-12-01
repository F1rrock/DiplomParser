import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';
import 'package:practise_parser/features/parser/domain/repositories/entity_repository.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_entities.dart';

class MockEntityRepository extends Mock implements EntityRepository {}

void main() {
  late GetListOfEntities useCase;
  late MockEntityRepository mockRepository;

  setUp(() {
    mockRepository = MockEntityRepository();
    useCase = GetListOfEntities(repository: mockRepository);
  });

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
    'test returns value from GetListOfEntities use case',
    () {
      test(
        'should get entity from repository',
            () async {
          //arrange
          when(() => mockRepository.getListOfRandomEntities())
              .thenAnswer((_) async => Right(testList));
          //act
          final result = await useCase(const NoParams());
          //assert
          expect(result, Right(testList));
          verify(() {
            mockRepository.getListOfRandomEntities();
          });
          verifyNoMoreInteractions(mockRepository);
        },
      );

      test(
        'should get failure from repository',
            () async {
          //arrange
          when(() => mockRepository.getListOfRandomEntities())
              .thenAnswer((_) async => const Left(ServerFailure()));
          //act
          final result = await useCase(const NoParams());
          //assert
          expect(result, const Left(testFailure));
          verify(() {
            mockRepository.getListOfRandomEntities();
          });
          verifyNoMoreInteractions(mockRepository);
        },
      );
    },
  );
}
