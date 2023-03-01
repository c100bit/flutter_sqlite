import 'package:flutter/material.dart';
import 'package:todo_models/todo_model.dart';
import 'package:todo_repository/todo_repository.dart';

class CreateTodo extends StatelessWidget {
  CreateTodo({Key? key}) : super(key: key);

  final teTitle = TextEditingController();
  final teDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: TextField(
              controller: teTitle,
              decoration: const InputDecoration(
                  hintText: 'Task name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: TextField(
              controller: teDescription,
              decoration: const InputDecoration(
                  hintText: 'Task time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )),
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                final todo = TodoModel(
                    id: 1,
                    title: teTitle.text,
                    description: teDescription.text);
                TodoRepository().addTodo(todo);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          )
        ],
      ),
    );
  }
}
