import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/api_services.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await apiService.getTasks();

      _tasks.clear();
      _tasks.addAll(
        data.map<Task>((item) {
        return Task(
          id: item['id'],
          name: item['title'],
          description: 'Loaded from JSONPlaceholder',
          category: null,
          priority: null,
          completed: item['completed'],
        );
      }),
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      final result = await apiService.createTask(
        task.name,
        task.completed,
      );

      task.id = result['id'];

      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final result = await apiService.updateTask(
        task.id!,
        task.name,
        task.completed,
      );

      task.name = result['title'];

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeTask(Task task) async {
    try {
      final newStatus = !task.completed;

      final result = await apiService.updateTask(
        task.id!,
        task.name,
        newStatus,
      );

      task.completed = result['completed'];

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await apiService.deleteTask(task.id!);

      _tasks.remove(task);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}