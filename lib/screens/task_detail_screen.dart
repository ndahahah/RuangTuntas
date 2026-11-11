import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final TaskModel task;

  String get formattedDeadline {
    final day = task.deadline.day.toString().padLeft(2, '0');
    final month = task.deadline.month.toString().padLeft(2, '0');
    final year = task.deadline.year;

    return '$day/$month/$year';
  }

  Future<void> _editTask(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteTask(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tugas?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus tugas "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final success = await context.read<TaskProvider>().removeTask(task.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Tugas berhasil dihapus.' : 'Gagal menghapus tugas.',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5267A5);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit Tugas',
            onPressed: () => _editTask(context),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Hapus Tugas',
            onPressed: () => _deleteTask(context),
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 42,
                color: primaryColor,
              ),
              const SizedBox(height: 18),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.subject,
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(height: 32),
              const Text(
                'Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                task.description.isEmpty
                    ? 'Tidak ada deskripsi tugas.'
                    : task.description,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tenggat Waktu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(formattedDeadline),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Status Tugas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    task.isCompleted ? Icons.check_circle : Icons.schedule,
                    color: task.isCompleted ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(task.isCompleted ? 'Selesai' : 'Belum Selesai'),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _editTask(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Tugas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _deleteTask(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Hapus Tugas'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
