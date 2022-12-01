import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';

void main() {
  const jokeAttributesModel = JokeAttributesModel(
    nsfw: false,
    religious: false,
    political: false,
    racist: false,
    sexist: false,
    explicit: false,
  );
  const testJokeModel = JokeModel(
    id: 1,
    setup: 'test name',
    category: 'test category',
    delivery: 'test description',
    flags: jokeAttributesModel,
  );
  test(
    'should be a subclass of ObjectEntity',
        () async {
      //assert
      expect(testJokeModel, isA<ObjectEntity>());
    },
  );
}
