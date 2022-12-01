import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

class JokeModel extends ObjectEntity {
  const JokeModel({
    required super.category,
    required String setup,
    required String delivery,
    required AttributesEntity flags,
    required super.id,
  }) : super(
          name: setup,
          description: '$setup\n$delivery',
          attributes: flags,
        );
}
