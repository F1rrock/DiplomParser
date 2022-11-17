import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/entity.dart';

abstract class EntityRepository {
  Future<Either<Failure, List<ObjectEntity>>> getListOfRandomEntities();
  Future<Either<Failure, List<ObjectEntity>>> searchEntitiesByCategory(String query);
}