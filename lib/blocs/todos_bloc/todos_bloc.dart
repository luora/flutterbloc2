

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_event.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_state.dart';

import '../../models/models.dart';

class TodosBloc extends Bloc<TodoEvent, TodosState>{
  TodosBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdateTodo>(_onUpdateTodo);

  }

  void _onLoadTodos(LoadTodos event, Emitter<TodosState> emit)async{

    await Future.delayed(const Duration(seconds: 3));
    emit(
      TodosLoaded(todos: event.todos)
    );

  }

  void _onAddTodo(AddTodo event, Emitter<TodosState> emit){

    final state = this.state;

    if(state is TodosLoaded){
      emit(
        TodosLoaded(
          todos: List.from(state.todos)..add(event.todo)
        )
      );
    }

  }

  void _onDeleteTodo( DeleteTodo event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.where((todo) {
        return todo.id != event.todo.id;
      })).toList();

      emit(TodosLoaded(todos: todos));
    }
  }

  void _onUpdateTodo( UpdateTodo event, Emitter<TodosState> emit){

    final state = this.state;

    if(state is TodosLoaded){

      print("update todo ${state.todos}");
      List<Todo> todos = (state.todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      })).toList();

      emit(TodosLoaded(todos: todos));
    }
  }
}