import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

class JokeModel extends ObjectEntity {
  final bool safe;
  final String lang;

  @override
  List<Object> get props => [
        id,
        name,
        category,
        description,
        attributes,
        safe,
        lang,
      ];

  const JokeModel({
    required this.safe,
    required this.lang,
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required JokeAttributesModel attributes,
  }) : super(attributes: attributes);
}
