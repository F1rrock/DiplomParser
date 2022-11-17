import 'package:equatable/equatable.dart';
import 'package:practise_parser/features/parser/data/models/joke_attributes_model.dart';

import '../../../../core/parsers/json_parser.dart';

class JokeAttributesMapper extends Equatable implements JsonParser<JokeAttributesModel> {
  @override
  List<Object> get props => [];

  @override
  JokeAttributesModel fromJson(Map<String, dynamic> json) {
    return JokeAttributesModel(
      nsfw: json['nsfw'] as bool,
      religious: json['religious'] as bool,
      political: json['political'] as bool,
      racist: json['racist'] as bool,
      sexist: json['sexist'] as bool,
      explicit: json['explicit'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson(JokeAttributesModel object) {
    return {
      'nsfw': object.nsfw,
      'religious': object.religious,
      'political': object.political,
      'racist': object.racist,
      'sexist': object.sexist,
      'explicit': object.explicit,
    };
  }

  const JokeAttributesMapper();
}