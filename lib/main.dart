import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_event.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_state.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_bloc.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_event.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_state.dart';
import 'package:flutterbloc2/models/models.dart';
import 'package:flutterbloc2/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodosBloc>(
            create: (context) {
              List<Todo> todos = [
                Todo(id: "1", task: "Task 1", description: "This is task 1"),
                Todo(id: "2", task: "Task 2", description: "This is task 2")
              ];

              return TodosBloc()..add(const LoadTodos(
                // todos: todos
              ));
            }
        ),

        BlocProvider<TodosStatusBloc>(
            create: (context){
              return TodosStatusBloc(
                  todosBloc: BlocProvider.of<TodosBloc>(context)
              )..add(LoadTodosStatus());


            }
        )
      ],
      child: MaterialApp(
        title: 'Todos app',
        theme: ThemeData(
          primarySwatch: Colors.blue,

          primaryColor: const Color(0x0ff8fa1f),


        ),
        home: const HomeScreen(),
      ),
    );
  }
}


