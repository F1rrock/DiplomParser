import 'package:practise_parser/features/parser/domain/entities/attributes_entity.dart';

class JokeAttributesModel extends AttributesEntity {
  final bool nsfw;
  final bool religious;
  final bool political;
  final bool racist;
  final bool sexist;
  final bool explicit;

  @override
  List<Object> get props => [
        nsfw,
        religious,
        political,
        racist,
        sexist,
        explicit,
      ];

  const JokeAttributesModel({
    required this.nsfw,
    required this.religious,
    required this.political,
    required this.racist,
    required this.sexist,
    required this.explicit,
  });

  @override
  String toString() {
    var response = '';
    response = nsfw ? '${response}nsfw; ' : response;
    response = religious ? '${response}religious; ' : response;
    response = political ? '${response}political; ' : response;
    response = racist ? '${response}racist; ' : response;
    response = sexist ? '${response}sexist; ' : response;
    response = explicit ? '${response}explicit; ' : response;
    return 'type: ${response == '' ? 'simple' : response.substring(
        0,
        response.length - 2,
      )}';
  }
}
