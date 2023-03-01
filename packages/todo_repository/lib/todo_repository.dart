import 'package:todo_models/todo_model.dart';
import 'package:todo_services/data_models/dbtodo.dart';
import 'package:todo_services/database.dart';

class TodoRepository {
  Future<void> addTodo(TodoModel todo) async {
    final getAllTodoD = await getAllTodo();

    await DBProvider.db.addTodo(DBTodo(
      id: getAllTodoD.isEmpty ? 1 : getAllTodoD.last.id + todo.id,
      title: todo.title,
      description: todo.description,
    ));
  }

  Future<List<TodoModel>> getAllTodo() async {
    final tt = await DBProvider.db.getAllTodo();
    return tt
        .map((e) =>
            TodoModel(id: e.id, title: e.title, description: e.description))
        .toList();
  }

  Future<int> updateTodo(TodoModel todo) async {
    final result = await DBProvider.db.updateTodo(DBTodo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
    ));

    return result;
  }

  Future<List<TodoModel>> searchTodo(String keyword) async {
    final tt = await DBProvider.db.searchTodo(keyword);
    return tt
        .map((e) => TodoModel(
              id: e.id,
              title: e.title,
              description: e.description,
            ))
        .toList();
  }

  Future<void> deleteTodoId(int id) async {
    await DBProvider.db.deleteTodoId(id);
  }

  Future<void> deleteAllTasks() async {
    await DBProvider.db.deleteAllTasks();
  }
}
