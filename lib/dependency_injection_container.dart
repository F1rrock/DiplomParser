import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:practise_parser/core/network/concrete/network_info_from_checker.dart';
import 'package:practise_parser/core/network/network_info.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_local_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/joke_remote_datasource.dart';
import 'package:practise_parser/features/parser/data/datasources/remote_datasources/joke_remote_datasource_from_url.dart';
import 'package:practise_parser/features/parser/data/mappers/joke_mapper.dart';
import 'package:practise_parser/features/parser/data/repositories/joke_repository.dart';
import 'package:practise_parser/features/parser/domain/repositories/entity_repository.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_entities.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/parser/data/datasources/local_datasources/joke_local_datasource_from_shared_prefs.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {

  // Use cases
  serviceLocator.registerLazySingleton(
    () => GetListOfEntities(
      repository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SearchEntities(
      repository: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<EntityRepository>(
    () => JokeRepository(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<JokeRemoteDataSource>(
    () => JokeRemoteDataSourceFromUrl(
      client: serviceLocator(),
      parser: const JokeMapper(),
    ),
  );

  serviceLocator.registerLazySingleton<JokeLocalDataSource>(
    () => JokeLocalDataSourceFromSharedPrefs(
      sharedPreferences: serviceLocator(),
      parser: const JokeMapper(),
    ),
  );

  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoFromChecker(
      connectionChecker: serviceLocator(),
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
    () => http.Client(),
  );
  serviceLocator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
}
