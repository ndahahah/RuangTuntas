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
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedTasks = await _repository.getTasks();
      _tasks = fetchedTasks;
    } catch (error) {
      debugPrint('Fetch tasks error: $error');
      _errorMessage =
          'Gagal mengambil data tugas. Periksa koneksi internet Anda.';
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
      debugPrint('Add task error: $error');
      _errorMessage = 'Gagal menambahkan tugas. Silakan coba kembali.';
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
      debugPrint('Update task error: $error');
      _errorMessage = 'Gagal memperbarui tugas. Silakan coba kembali.';
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
      debugPrint('Delete task error: $error');
      _errorMessage = 'Gagal menghapus tugas. Silakan coba kembali.';
      notifyListeners();

      return false;
    }
  }

  // Mengubah status tugas
  Future<bool> toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    return updateTask(updatedTask);
  }
}
