
import 'package:flutter_test/flutter_test.dart';
import 'package:uts_indah_susanti_079/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('berhasil membuat model dari JSON', () {
      final task = TaskModel.fromJson({
        'id': '1',
        'title': 'Mengerjakan UTS',
        'description': 'Membuat aplikasi Flutter',
        'subject': 'Pemrograman Mobile',
        'deadline': '2026-11-20',
        'is_completed': false,
      });

      expect(task.id, '1');
      expect(task.title, 'Mengerjakan UTS');
      expect(task.subject, 'Pemrograman Mobile');
      expect(task.isCompleted, false);
    });

    test('berhasil mengubah model menjadi JSON', () {
      final task = TaskModel(
        id: '2',
        title: 'Membuat laporan',
        description: 'Laporan UTS',
        subject: 'Pemrograman Mobile',
        deadline: DateTime(2026, 11, 20),
        isCompleted: true,
      );

      final json = task.toJson();

      expect(json['id'], '2');
      expect(json['title'], 'Membuat laporan');
      expect(json['is_completed'], true);
      expect(json['deadline'], '2026-11-20');
    });

    test('copyWith berhasil mengubah status tugas', () {
      final task = TaskModel(
        id: '3',
        title: 'Belajar Flutter',
        subject: 'Pemrograman Mobile',
        deadline: DateTime(2026, 11, 20),
      );

      final updatedTask = task.copyWith(isCompleted: true);

      expect(updatedTask.isCompleted, true);
      expect(updatedTask.title, task.title);
      expect(updatedTask.id, task.id);
    });

    test('menggunakan nilai default untuk field opsional', () {
      final task = TaskModel.fromJson({
        'title': 'Belajar Flutter',
        'subject': 'Pemrograman Mobile',
        'deadline': '2026-11-20',
      });

      expect(task.id, '');
      expect(task.description, '');
      expect(task.isCompleted, false);
    });
  });
}
