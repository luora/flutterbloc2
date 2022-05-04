
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class TodosStatusEvent extends Equatable{
  const TodosStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadTodosStatus extends TodosStatusEvent {

}

class UpdateTodosStatus extends TodosStatusEvent{
  final List<Todo> todos;

  const UpdateTodosStatus({this.todos = const <Todo>[]});

  @override
  List<Object> get props => [todos];
}