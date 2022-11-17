import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/core/use_cases/use_case.dart';

import '../entities/entity.dart';
import '../repositories/entity_repository.dart';

class GetListOfEntities implements UseCase<List<ObjectEntity>, NoParams> {
  final EntityRepository repository;

  const GetListOfEntities({
    required this.repository
  });

  @override
  Future<Either<Failure, List<ObjectEntity>>> call(NoParams param) async {
    return await repository.getListOfRandomEntities();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];

  const NoParams();
}