import 'package:flutter/material.dart';
import 'package:flutter_sqlite/create_todo/create_todo.dart';
import 'package:todo_models/todo_model.dart';
import 'package:todo_repository/todo_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final keyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: TextField(
                controller: keyword,
                onSubmitted: (value) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        TodoRepository().searchTodo(keyword.text);
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        keyword.text = '';
                      },
                      icon: const Icon(Icons.clear)),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            )),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                TodoRepository().deleteAllTasks();
              });
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder(
        future: keyword.text.isNotEmpty
            ? TodoRepository().searchTodo(keyword.text)
            : TodoRepository().getAllTodo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final todo = snapshot.data as List<TodoModel>;
          return ListView.builder(
            itemCount: todo.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                          child: ListTile(
                        title: Text(todo[index].title),
                        subtitle: Text(todo[index].description),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              TodoRepository().deleteTodoId(todo[index].id);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateTodo()));
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}
