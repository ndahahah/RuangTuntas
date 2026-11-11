import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDeadline;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      helpText: 'Pilih tenggat tugas',
    );

    if (selected != null) {
      setState(() {
        _selectedDeadline = selected;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tenggat tugas.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final task = TaskModel(
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      deadline: _selectedDeadline!,
    );

    final success = await context.read<TaskProvider>().addTask(task);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil ditambahkan.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan tugas. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deadlineText = _selectedDeadline == null
        ? 'Pilih tanggal tenggat'
        : '${_selectedDeadline!.day.toString().padLeft(2, '0')}/'
              '${_selectedDeadline!.month.toString().padLeft(2, '0')}/'
              '${_selectedDeadline!.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambahkan Tugas Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi informasi tugas kuliahmu.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),

              const Text('Judul Tugas'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration(
                  'Masukkan judul tugas',
                  Icons.assignment_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tugas wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text('Mata Kuliah'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: _inputDecoration(
                  'Masukkan nama mata kuliah',
                  Icons.menu_book_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mata kuliah wajib diisi.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),
              const Text('Deskripsi'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _inputDecoration(
                  'Tuliskan deskripsi tugas',
                  Icons.description_outlined,
                ),
              ),

              const SizedBox(height: 18),
              const Text('Tenggat Tugas'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDeadline,
                child: InputDecorator(
                  decoration: _inputDecoration(
                    'Pilih tanggal tenggat',
                    Icons.calendar_month_outlined,
                  ),
                  child: Text(deadlineText),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveTask,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Tugas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5267A5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF5267A5), width: 1.5),
      ),
    );
  }
}
