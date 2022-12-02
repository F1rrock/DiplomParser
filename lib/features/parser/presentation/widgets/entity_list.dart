import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/features/parser/domain/entities/entity.dart';
import 'package:practise_parser/features/parser/presentation/ploc/entity_bloc.dart';
import 'package:practise_parser/features/parser/presentation/ploc/events/concrete_events/get_list_of_entities_event.dart';

import 'entity_card.dart';

class EntityList extends StatelessWidget {
  const EntityList({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<ObjectEntity> list;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<EntityBloc>();
        bloc.add(bloc.lastQuery);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (_, index) {
          return ListTile(
            title: EntityCard(
              entity: list[index],
            ),
          );
        },
        separatorBuilder: (_, index) => const Divider(),
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }
}
