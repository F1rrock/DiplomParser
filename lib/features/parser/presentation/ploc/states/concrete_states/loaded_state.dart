import 'package:practise_parser/features/parser/presentation/ploc/states/entity_state.dart';

import '../../../../domain/entities/entity.dart';

class LoadedState extends EntityState {
  final List<ObjectEntity> entities;
  final bool isFirstFetch;

  const LoadedState({
    required this.entities,
    this.isFirstFetch = false,
  });

  @override
  List<Object> get props => [
    entities,
  ];
}
