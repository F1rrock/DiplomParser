import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/dependency_injection_container.dart';
import 'package:practise_parser/features/parser/presentation/ploc/bloc.dart';
import 'package:practise_parser/features/parser/presentation/widgets/widgets.dart';

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
