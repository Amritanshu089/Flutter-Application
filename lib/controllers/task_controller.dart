import 'package:get/get.dart';
import '../models/task.dart';
import '../services/api_services.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();

  final tasks        = <Task>[].obs;
  final isLoading    = false.obs;
  final errorMessage = Rxn<String>();
  var searchText     = ''.obs;

  // ── Filtered tasks (search by name & description) ───────────────────────────
  List<Task> get filteredTasks {
    if (searchText.value.isEmpty) {
      return tasks;
    }

    final query = searchText.value.toLowerCase();

    return tasks.where((task) {
      return task.name.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();
  }

  // ── Counter (kept for demo purposes) ────────────────────────────────────────
  var count = 0.obs;
  void increment() => count++;
  void decrement() => count--;

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // ── CRUD operations ─────────────────────────────────────────────────────────
  Future<void> loadTasks() async {
    isLoading.value    = true;
    errorMessage.value = null;

    try {
      final data = await _apiService.getTasks();
      tasks.assignAll(
        data.map<Task>((item) => Task(
          id:          item['id'],
          name:        item['title'],
          description: 'Loaded from JSONPlaceholder',
          completed:   item['completed'],
        )),
      );
    } catch (e) {
      errorMessage.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> addTask(Task task) async {
    try {
      final result = await _apiService.createTask(task.name, task.completed);
      task.id = result['id'];
      tasks.add(task);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final result = await _apiService.updateTask(task.id!, task.name, task.completed);
      task.name = result['title'];
      tasks.refresh(); // notify UI after in-place mutation
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> completeTask(Task task) async {
    try {
      final newStatus = !task.completed;
      final result    = await _apiService.updateTask(task.id!, task.name, newStatus);
      task.completed  = result['completed'];
      tasks.refresh();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _apiService.deleteTask(task.id!);
      tasks.remove(task);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}