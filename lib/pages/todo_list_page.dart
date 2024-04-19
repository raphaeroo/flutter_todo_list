import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/widgets/task_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _controller = TextEditingController();

  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your task',
                          hintText: 'e.g. Buy milk',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = _controller.text;
                        Task newTask = Task(title: text, date: DateTime.now());

                        setState(() {
                          tasks.add(newTask);
                        });
                        _controller.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (tasks.isNotEmpty)
                        for (Task task in tasks)
                          TaskItem(
                            task: task,
                            onDelete: deleteTask,
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('You have ${tasks.length} tasks to do'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        List<Task> tasksClone = tasks;

                        setState(() {
                          tasks = [];
                        });

                        showSnackbar('All tasks have been cleared', () {
                          setState(() {
                            tasks = tasksClone;
                            tasksClone = [];
                          });
                        });
                      },
                      child: const Text('Clear all'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackbar(String title, void Function() onPressed) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: onPressed,
        ),
      ),
    );
  }

  void deleteTask(Task task) {
    int? index = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });

    showSnackbar('Task "${task.title}" has been deleted', () {
      setState(() {
        tasks.insert(index, task);
      });
    });
  }
}
