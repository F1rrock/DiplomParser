import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/dependency_injection_container.dart';
import 'package:practise_parser/features/parser/presentation/ploc/events/concrete_events/get_list_of_entities_event.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/empty_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/error_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/loaded_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/loading_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/entity_state.dart';
import 'package:practise_parser/features/parser/presentation/widgets/entity_list.dart';

import '../ploc/entity_bloc.dart';

class EntitiesPage extends StatelessWidget {
  const EntitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('jokes parser'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<EntityBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<EntityBloc>()..add(const GetListOfEntitiesEvent()),
      child: Center(
        child: BlocBuilder<EntityBloc, EntityState>(
          builder: (_, state) {
            if (state is EmptyState) {
              return const Text('nothing');
            } else if (state is LoadingState) {
              return const CircularProgressIndicator();
            } else if (state is LoadedState) {
              return EntityList(
                list: state.entities,
              );
            } else if (state is ErrorState) {
              return Text(state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
