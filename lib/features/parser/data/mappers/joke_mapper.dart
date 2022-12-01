import 'package:equatable/equatable.dart';
import 'package:practise_parser/core/parsers/json_parser.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

class JokeMapper extends Equatable implements JsonParser<ObjectEntity> {
  final JsonParser<AttributesEntity> attributesMapper;

  @override
  List<Object> get props => [];

  @override
  ObjectEntity fromJson(Map<String, dynamic> json) {
    return JokeModel(
      id: (json['id'] as num).toInt(),
      setup: json['setup'],
      category: json['category'],
      delivery: json['delivery'],
      flags:
          attributesMapper.fromJson(json['flags'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson(ObjectEntity object) {
    return {
      'type': 'twopart',
      'id': object.id,
      'setup': object.name,
      'category': object.category,
      'delivery': object.description.replaceAll('${object.name}\n', ''),
      'flags': attributesMapper.toJson(object.attributes),
    };
  }

  const JokeMapper({
    required this.attributesMapper
  });
}
