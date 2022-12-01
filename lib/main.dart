import 'package:flutter/material.dart';
import 'package:practise_parser/features/parser/presentation/pages/entities_page.dart';
import 'dependency_injection_container.dart' as dependency_injection;

const serverFailureMessage = 'server error';
const cacheFailureMessage = 'cache error';

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
      home: const EntitiesPage(),
    );
  }
}
