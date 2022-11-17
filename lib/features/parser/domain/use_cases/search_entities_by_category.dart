import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/core/use_cases/use_case.dart';

import '../entities/entity.dart';
import '../repositories/entity_repository.dart';

class SearchEntitiesByCategory implements UseCase<List<ObjectEntity>, Params> {
  final EntityRepository repository;

  const SearchEntitiesByCategory({
    required this.repository
  });

  @override
  Future<Either<Failure, List<ObjectEntity>>> call(Params param) async {
    return await repository.searchEntitiesByCategory(param.query);
  }
}

class Params extends Equatable {
  final String query;

  const Params({
    required this.query
  });

  @override
  List<Object> get props => [query];
}