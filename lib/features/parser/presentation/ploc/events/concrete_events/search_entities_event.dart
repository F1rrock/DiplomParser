import 'package:practise_parser/features/parser/presentation/ploc/events/entity_event.dart';

class SearchEntitiesEvent extends EntityEvent {
  final String query;

  const SearchEntitiesEvent({
    required this.query,
  });

  @override
  List<Object> get props => [
    query,
  ];
}