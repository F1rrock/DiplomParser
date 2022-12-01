import 'package:practise_parser/features/parser/presentation/ploc/states/entity_state.dart';

class ErrorState extends EntityState {
  final String message;

  const ErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
    message,
  ];
}
