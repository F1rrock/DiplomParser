import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practise_parser/core/util/input_checker.dart';

void main() {
  late InputChecker inputConverter;

  setUp(() {
    inputConverter = InputChecker();
  });

  group('to string without special symbols', () {
    test(
      'should return a string when the string '
          'represents a string without special symbols',
      () async {
        // arrange
        const str = 'misc';
        // act
        final result = inputConverter.checkIsStringWithoutSpecialCharacters(str);
        // assert
        expect(result, const Right('misc'));
      },
    );

    test(
      'should return a invalid input failure when the string '
          'is a string without special symbols',
          () async {
        // arrange
        const str = 'misc?';
        // act
        final result = inputConverter.checkIsStringWithoutSpecialCharacters(str);
        // assert
        expect(result, const Left(InvalidInputFailure()));
      },
    );
  });
}
