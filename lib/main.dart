import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/features/parser/presentation/pages/entities_page.dart';
import 'dependency_injection_container.dart' as dependency_injection;
import 'dependency_injection_container.dart';
import 'package:practise_parser/features/parser/presentation/ploc/bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'parser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      home: BlocProvider(
        create: (_) =>
            serviceLocator<EntityBloc>()..add(const GetListOfEntitiesEvent()),
        child: const EntitiesPage(),
      ),
    );
  }
}
