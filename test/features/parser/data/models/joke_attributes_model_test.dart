import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';

void main() {
  const testJokeAttributesModel = JokeAttributesModel(
    nsfw: false,
    religious: false,
    political: false,
    racist: false,
    sexist: false,
    explicit: false,
  );

  test(
    'should be a subclass of ObjectEntity',
    () async {
      //assert
      expect(testJokeAttributesModel, isA<AttributesEntity>());
    },
  );
}
