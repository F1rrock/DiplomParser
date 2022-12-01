import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_attributes_mapper.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_mapper.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const jokeAttributesModel = JokeAttributesModel(
    nsfw: true,
    religious: false,
    political: false,
    racist: false,
    sexist: false,
    explicit: true,
  );
  const testJokeModel = JokeModel(
    category: "Misc",
    setup: "What do you call a bird sitting with their legs spread?",
    delivery: "A prostitweety.",
    flags: jokeAttributesModel,
    id: 224,
  );
  const testJokeMapper = JokeMapper(
    attributesMapper: JokeAttributesMapper(),
  );

  group('joke from Json', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('joke.json'));
        // act
        final result = testJokeMapper.fromJson(jsonMap);
        //assert
        expect(result, testJokeModel);
      },
    );
  });

  group('joke to Json', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = testJokeMapper.toJson(testJokeModel);
        //assert
        final expectedMap = {
          "category": "Misc",
          "type": "twopart",
          "setup": "What do you call a bird sitting with their legs spread?",
          "delivery": "A prostitweety.",
          "flags": {
            "nsfw": true,
            "religious": false,
            "political": false,
            "racist": false,
            "sexist": false,
            "explicit": true
          },
          "id": 224,
        };
        expect(result, expectedMap);
      },
    );
  });
}
