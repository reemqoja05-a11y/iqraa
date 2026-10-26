import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await _supabase
        .from('tasks')
        .select()
        .order('id', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}