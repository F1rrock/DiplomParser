import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/features/parser/presentation/ploc/bloc.dart';
import 'package:practise_parser/features/parser/presentation/widgets/widgets.dart';

class EntitiesPage extends StatelessWidget {
  const EntitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('jokes parser'),
      centerTitle: false,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 35.0,
              width: MediaQuery.of(context).size.width / 3,
              child: TextField(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  if (text.isEmpty) {
                    /*context
                        .read<EntityBloc>()
                        .add(const GetListOfEntitiesEvent());*/
                    context
                        .read<EntityBloc>()
                        .execute(const GetListOfEntitiesEvent());
                  } else {
                    /*context
                        .read<EntityBloc>()
                        .add(SearchEntitiesEvent(query: text));*/
                    context
                        .read<EntityBloc>()
                        .execute(SearchEntitiesEvent(query: text));
                  }
                },
              ),
            ),
            const Icon(
              Icons.search,

            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
