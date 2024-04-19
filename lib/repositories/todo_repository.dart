import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/task.dart';

const todoListKey = 'todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Task>> loadTasks() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString) as List;
    return jsonList.map((e) => Task.fromJson(e)).toList();
  }

  void saveTasks(List<Task> tasks) {
    final String jsonString = json.encode(tasks);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
