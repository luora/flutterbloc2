

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_state.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_event.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_state.dart';
import 'package:flutterbloc2/models/models.dart';

class TodosStatusBloc extends Bloc<TodosStatusEvent, TodosStatusState>{
  final TodosBloc _todosBloc;
  late StreamSubscription _todoSubscription;
  
  TodosStatusBloc({required TodosBloc todosBloc})
      : _todosBloc = todosBloc,
        super(TodosStatusLoading()){
    
    on<UpdateTodosStatus>(_onUpdateTodoStatus);

    on<LoadTodosStatus>(_onLoadTodoStatus);
    _todoSubscription = _todosBloc.stream.listen((state) { 
      if(state is TodosLoaded){
        add(
          UpdateTodosStatus(todos: state.todos)
        );
      }
    });
  }

  void _onLoadTodoStatus(LoadTodosStatus event , Emitter<TodosStatusState> emit )async {

    await Future.delayed(const Duration(seconds: 3));
    emit(
      const TodosStatusLoaded()
    );

  }
  
  void _onUpdateTodoStatus(UpdateTodosStatus event, Emitter<TodosStatusState> emit) async {

   // await Future.delayed(const Duration(seconds: 3));

    List<Todo> todos = event.todos;
    
    List<Todo> pendingTodos = todos.where(
            (todo) => todo.isCancelled == false && todo.isCompleted == false).toList();

    List<Todo> cancelledTodos = todos.where(
            (todo) => todo.isCancelled == true).toList();

    List<Todo> completedTodos = todos.where(
            (todo) => todo.isCancelled == false && todo.isCompleted == true).toList();

    emit(
      TodosStatusLoaded(
        pendingTodos: pendingTodos,
        completedTodos: completedTodos,
        cancelledTodos: cancelledTodos
      )
    );

    print("All todos $todos");

    print("Pending todos $pendingTodos");

    print("Cancelled todos $cancelledTodos");

    print("Completed todos $completedTodos");
    
  }

  @override
  Future<void> close() {
    _todoSubscription.cancel();
    return super.close();
  }
  
}