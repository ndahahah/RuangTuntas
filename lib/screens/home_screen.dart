import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TaskProvider>().fetchTasks();
      }
    });
  }

  Future<void> _openAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );

    if (!mounted) return;

    // Memastikan dashboard menampilkan data terbaru.
    context.read<TaskProvider>().fetchTasks();
  }

  void _openTaskList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TaskListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RuangTuntas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            tooltip: 'Daftar Tugas',
            icon: const Icon(Icons.list_alt),
            onPressed: _openTaskList,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        backgroundColor: const Color(0xFF5267A5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),

      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.fetchTasks,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 650;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Selamat Datang di RuangTuntas!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Atur tugas kuliahmu dan selesaikan tepat waktu.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Ringkasan Tugas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    GridView.count(
                      crossAxisCount: isWide ? 3 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.8 : 1.2,
                      children: [
                        SummaryCard(
                          title: 'Total Tugas',
                          count: provider.totalTasks,
                          icon: Icons.assignment_outlined,
                          color: const Color(0xFF5267A5),
                        ),
                        SummaryCard(
                          title: 'Selesai',
                          count: provider.completedTasks,
                          icon: Icons.task_alt,
                          color: Colors.green,
                        ),
                        SummaryCard(
                          title: 'Belum Selesai',
                          count: provider.pendingTasks,
                          icon: Icons.pending_actions,
                          color: Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tugas Terbaru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${provider.totalTasks} tugas',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (provider.isLoading && provider.tasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (provider.errorMessage != null &&
                        provider.tasks.isEmpty)
                      _buildError(provider)
                    else if (provider.tasks.isEmpty)
                      _buildEmptyState()
                    else
                      ...provider.tasks
                          .take(5)
                          .map(
                            (task) => TaskCard(
                              task: task,
                              onToggle: () async {
                                final success = await provider.toggleTaskStatus(
                                  task,
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? 'Status tugas berhasil diperbarui.'
                                          : 'Gagal memperbarui tugas.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: Color(0xFF5267A5)),
            SizedBox(height: 12),
            Text(
              'Belum ada tugas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Tugas yang kamu tambahkan akan muncul di sini.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(TaskProvider provider) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            const Text('Gagal memuat data tugas'),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: provider.fetchTasks,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
