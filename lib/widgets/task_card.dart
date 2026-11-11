import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final TaskModel task;
  final VoidCallback onToggle;

  String get formattedDeadline {
    final day = task.deadline.day.toString().padLeft(2, '0');
    final month = task.deadline.month.toString().padLeft(2, '0');
    final year = task.deadline.year;

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: const Color(0xFF5267A5),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('${task.subject} • Tenggat: $formattedDeadline'),
        ),
        trailing: Icon(
          task.isCompleted ? Icons.check_circle : Icons.schedule,
          color: task.isCompleted ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
