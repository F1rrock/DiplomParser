import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practise_parser/core/error/failures.dart';
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

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final GetListOfEntities getEntities;
  final SearchEntities searchEntities;

  EntityBloc({
    required this.getEntities,
    required this.searchEntities,
  }) : super(const EmptyState()) {
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
    });
  }

  /*@override
  Stream<JokeState> mapEventToState(JokeEvent event) async* {
    if (event is GetListOfJokes) {
      yield const LoadingState();
      final failureOrJokes = await getJokes(const NoParams());
      yield* _eitherLoadedOrErrorState(failureOrJokes);
    } else if (event is SearchJokesByCategory) {
      yield const LoadingState();
      final failureOrJokes = await getEntitiesByCategory(
        Params(query: event.category),
      );
      yield* _eitherLoadedOrErrorState(failureOrJokes);
    }
  }*/

  /*Stream<EntityState> _eitherLoadedOrErrorState(
      Either<Failure, List<ObjectEntity>> failureOrJokes) async* {
    yield failureOrJokes.fold(
      (failure) => ErrorState(message: _mapFailureToMessage(failure)),
      (jokes) => LoadedState(jokes: jokes),
    );
  }*/

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
