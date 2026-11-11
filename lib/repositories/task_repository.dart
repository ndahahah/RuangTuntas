import '../models/task_model.dart';
import '../services/supabase_service.dart';

class TaskRepository {
  final SupabaseService _service;

  TaskRepository({SupabaseService? service})
    : _service = service ?? SupabaseService();

  // Mengambil data tugas
  Future<List<TaskModel>> getTasks() async {
    final response = await _service.fetchTasks();

    return response.map((data) => TaskModel.fromJson(data)).toList();
  }

  // Menambahkan tugas baru
  Future<TaskModel> createTask(TaskModel task) async {
    final data = task.toJson();
    data.remove('id');

    final response = await _service.insertTask(data);

    return TaskModel.fromJson(response);
  }

  // Memperbarui tugas
  Future<TaskModel> updateTask(TaskModel task) async {
    if (task.id.isEmpty) {
      throw ArgumentError('ID tugas tidak boleh kosong.');
    }

    final data = task.toJson();
    data.remove('id');

    final response = await _service.updateTask(task.id, data);

    return TaskModel.fromJson(response);
  }

  // Menghapus tugas
  Future<void> deleteTask(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID tugas tidak boleh kosong.');
    }

    await _service.deleteTask(id);
  }
}
