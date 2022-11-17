import 'package:equatable/equatable.dart';
import 'package:practise_parser/core/parsers/json_parser.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_attributes_mapper.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';

class JokeMapper extends Equatable implements JsonParser<JokeModel> {
  final JokeAttributesMapper attributesMapper;

  @override
  List<Object> get props => [];

  @override
  JokeModel fromJson(Map<String, dynamic> json) {
    return JokeModel(
      safe: json['safe'] as bool,
      lang: json['lang'],
      id: (json['id'] as num).toInt(),
      name: json['setup'],
      category: json['category'],
      description: '${json['setup']}\n${json['delivery']}',
      attributes:
          attributesMapper.fromJson(json['flags'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson(JokeModel object) {
    return {
      'safe': object.safe,
      'lang': object.lang,
      'id': object.id,
      'setup': object.name,
      'category': object.category,
      'delivery': object.description.replaceAll(object.name, ''),
    };
  }

  const JokeMapper() : attributesMapper = const JokeAttributesMapper();
}
