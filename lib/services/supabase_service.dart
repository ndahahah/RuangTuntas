import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient? _providedClient;

  SupabaseService({SupabaseClient? client}) : _providedClient = client;

  // Supabase baru diakses ketika benar-benar diperlukan.
  SupabaseClient get _client {
    return _providedClient ?? Supabase.instance.client;
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> insertTask(Map<String, dynamic> data) async {
    final response = await _client.from('tasks').insert(data).select().single();

    return response;
  }

  Future<Map<String, dynamic>> updateTask(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await _client
        .from('tasks')
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return response;
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }
}
