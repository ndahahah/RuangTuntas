import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  TaskProvider({TaskRepository? repository})
    : _repository = repository ?? TaskRepository();

  List<TaskModel> _tasks = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  // Mengambil data tugas dari Supabase
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan tugas
  Future<bool> addTask(TaskModel task) async {
    try {
      final newTask = await _repository.createTask(task);

      _tasks.insert(0, newTask);
      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();

      return false;
    }
  }

  // Memperbarui tugas
  Future<bool> updateTask(TaskModel task) async {
    try {
      final updatedTask = await _repository.updateTask(task);

      final index = _tasks.indexWhere((item) => item.id == updatedTask.id);

      if (index != -1) {
        _tasks[index] = updatedTask;
      }

      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();

      return false;
    }
  }

  // Menghapus tugas
  Future<bool> removeTask(String id) async {
    try {
      await _repository.deleteTask(id);

      _tasks.removeWhere((task) => task.id == id);

      _errorMessage = null;
      notifyListeners();

      return true;
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();

      return false;
    }
  }

  // Mengubah status tugas selesai/belum selesai
  Future<bool> toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    return updateTask(updatedTask);
  }
}
