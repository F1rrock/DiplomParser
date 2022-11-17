import 'package:equatable/equatable.dart';
import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';

class ObjectEntity extends Equatable {
  final int id;
  final String name;
  final String category;
  final String description;
  final AttributesEntity attributes;

  @override
  List<Object> get props => [
        id,
        name,
        category,
        description,
        attributes,
      ];

  const ObjectEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.attributes,
  });
}
