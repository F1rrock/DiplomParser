import 'package:flutter/material.dart';
import 'package:practise_parser/features/parser/data/models/joke_model.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_entities.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities.dart';
import 'dependency_injection_container.dart' as dependency_injection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();

  // var a = dependency_injection.serviceLocator<GetListOfRandomEntities>();
  // print(await a(const NoParams()));

  var searchEntity = dependency_injection.serviceLocator<SearchEntities>();
  var jokesOrFailure = await searchEntity(const Params(query: 'Dark'));
  jokesOrFailure.fold(
          (failure) => print('error'),
          (entities) => entities.forEach((entity) {
            print('id: ${entity.id}');
            print('category: ${entity.category}');
            print('name: ${entity.name}');
            print('description: ${entity.description}');
            print('attributes: ${entity.attributes}');
          }),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}



