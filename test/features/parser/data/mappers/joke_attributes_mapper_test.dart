import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_attributes_mapper.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testJokeAttributesModel = JokeAttributesModel(
    nsfw: true,
    religious: false,
    political: false,
    racist: false,
    sexist: false,
    explicit: true,
  );
  const testJokeAttributesMapper = JokeAttributesMapper();

  group('attributes from Json', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('joke_attributes.json'));
        // act
        final result = testJokeAttributesMapper.fromJson(jsonMap);
        //assert
        expect(result, testJokeAttributesModel);
      },
    );
  });

  group('attributes to Json', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = testJokeAttributesMapper.toJson(testJokeAttributesModel);
        //assert
        final expectedMap = {
          "nsfw": true,
          "religious": false,
          "political": false,
          "racist": false,
          "sexist": false,
          "explicit": true
        };
        expect(result, expectedMap);
      },
    );
  });
}
