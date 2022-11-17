import 'package:flutter/material.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_random_entities.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities_by_category.dart';
import 'dependency_injection_container.dart' as dependency_injection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();

  // var a = dependency_injection.serviceLocator<GetListOfRandomEntities>();
  // print(await a(const NoParams()));

  var b = dependency_injection.serviceLocator<SearchEntitiesByCategory>();
  print(await b(const Params(query: 'Dark')));
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



