import 'package:dartz/dartz.dart';
import 'package:practise_parser/core/error/failures.dart';

class InvalidInputFailure extends Failure {
  const InvalidInputFailure();
}

class InputChecker {
  final regExp = RegExp(
      r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
      "'"
          ']'
  );
  
  Either<Failure, String> checkIsStringWithoutSpecialCharacters(String str) {
    if (str.contains(regExp)) {
      return const Left(InvalidInputFailure());
    } else {
      return Right(str);
    }
  }
}