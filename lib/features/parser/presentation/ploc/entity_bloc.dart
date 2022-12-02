import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/core/error/failures.dart';
import 'package:practise_parser/core/util/input_checker.dart';
import 'package:practise_parser/features/parser/domain/use_cases/get_list_of_entities.dart';
import 'package:practise_parser/features/parser/domain/use_cases/search_entities.dart';
import 'package:practise_parser/features/parser/presentation/ploc/events/entity_event.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/empty_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/loaded_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/loading_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/entity_state.dart';
import 'package:practise_parser/features/parser/presentation/ploc/states/concrete_states/error_state.dart';

import 'events/concrete_events/get_list_of_entities_event.dart';
import 'events/concrete_events/search_entities_event.dart';

const serverFailureMessage = 'server error';
const cacheFailureMessage = 'cache error';
const inputFailureMessage = 'input failure';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final GetListOfEntities getEntities;
  final SearchEntities searchEntities;
  final InputChecker inputChecker;
  EntityEvent _lastQuery;

  get lastQuery => _lastQuery;

  EntityBloc({
    required this.getEntities,
    required this.searchEntities,
    required this.inputChecker,
  })  : _lastQuery = const GetListOfEntitiesEvent(),
        super(const EmptyState()) {
    on<GetListOfEntitiesEvent>((event, emit) async {
      emit(const LoadingState());
      final failureOrJokes = await getEntities(const NoParams());
      emit(
        failureOrJokes.fold(
          (failure) => ErrorState(
            message: _mapFailureToMessage(failure),
          ),
          (jokes) => LoadedState(
            entities: jokes,
          ),
        ),
      );
    });

    on<SearchEntitiesEvent>((event, emit) async {
      final inputEither =
          inputChecker.checkIsStringWithoutSpecialCharacters(event.query);

      await inputEither.fold(
        (failure) async {
          emit(const ErrorState(message: inputFailureMessage));
        },
        (query) async {
          emit(const LoadingState());
          final failureOrJokes = await searchEntities(
            Params(query: event.query),
          );
          emit(
            failureOrJokes.fold(
              (failure) => ErrorState(
                message: _mapFailureToMessage(failure),
              ),
              (entities) => LoadedState(
                entities: entities,
              ),
            ),
          );
        },
      );
    });
  }

  void execute(EntityEvent event) async {
    _lastQuery = event;
    add(event);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
