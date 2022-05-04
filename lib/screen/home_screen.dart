import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc2/blocs/todos_bloc/todos_state.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_bloc.dart';
import 'package:flutterbloc2/blocs/todos_status_bloc/todos_status_state.dart';

import '../blocs/todos_bloc/todos_bloc.dart';
import '../blocs/todos_bloc/todos_event.dart';
import '../models/todos_model.dart';
import 'add_todo_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          title: const Text('BloC Pattern: To Dos'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTodoScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.pending),
                  text: "pending todos",
                ),
                Tab(
                  icon: Icon(Icons.incomplete_circle_outlined),
                  text: "completed todos",
                ),

                Tab(
                  icon: Icon(Icons.incomplete_circle),
                  text: "cancelled todos",
                )
              ]),
        ),

        body: TabBarView(
            children:[

              BlocBuilder<TodosStatusBloc, TodosStatusState>(
                  builder: (context, state) {

                    if(state is TodosStatusLoading){
                      return const Center(
                        child: CircularProgressIndicator() ,
                      );
                    }else if(state is TodosStatusLoaded){
                      if(state.pendingTodos.isEmpty){
                        return const Center(
                          child: Text("empty list"),
                        );
                      }
                      return _todo(state.pendingTodos, "pending");
                    }else {
                      return const Center(
                      child: Text("something went wrong"),
                      );
                    }

                  }
                  ),


              BlocBuilder<TodosStatusBloc, TodosStatusState>(
                  builder: (context, state){

                    if(state is TodosStatusLoading){
                      return const Center(
                        child: CircularProgressIndicator() ,
                      );
                    }else if(state is TodosStatusLoaded){

                      if(state.completedTodos.isEmpty){
                        return const Center(
                          child: Text("empty list"),
                        );
                      }

                      return _todo(state.completedTodos, "completed");
                    }else {
                      return const Center(
                        child: Text("something went wrong"),
                      );
                    }

                  }

              ),

              BlocBuilder<TodosStatusBloc, TodosStatusState>(
                  builder: (context, state){

                    if(state is TodosStatusLoading){
                      return const Center(
                        child: CircularProgressIndicator() ,
                      );
                    }else if(state is TodosStatusLoaded){

                      if(state.cancelledTodos.isEmpty){
                        return const Center(
                          child: Text("empty list"),
                        );
                      }

                      return _todo(state.cancelledTodos, "completed");
                    }else {
                      return const Center(
                        child: Text("something went wrong"),
                      );
                    }
                  }

              ),
            ]),


      ),
    );
  }


  Column _todo(List<Todo> todos, String status){
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Text(
                '$status To dos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),

              ),

            ],
          ),
        ),

        ListView.builder(
            shrinkWrap: true,
            itemCount: todos.length,
            itemBuilder: (context, index){
              return _todosCard(context, todos[index]);
            }
        )
      ],
    );
  }

  Card _todosCard(BuildContext context, Todo todo){


    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            BlocBuilder<TodosBloc, TodosState>(
              builder: (context, state){
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<TodosBloc>().add(
                          UpdateTodo(
                            todo: todo.copyWith(isCompleted: true),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_task),
                    ),

                    IconButton(
                      onPressed: () {
                        context.read<TodosBloc>().add(
                          DeleteTodo(
                            todo: todo.copyWith(isCancelled: true),
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );

  }
}
