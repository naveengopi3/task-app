import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/models/task_model.dart';


final supabase = Supabase.instance.client;

class TaskService {
  Stream<List<Task>> taskStream(String userId) {
    return supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.map((e) => Task.fromJson(e)).toList());
  }
 

  Future<void> createTask(Task task) async {
    await supabase.from('tasks').insert(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await supabase
        .from('tasks')
        .update(task.toJson())
        .eq('id', task.id);
  }

  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').delete().eq('id', taskId);
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .gte('date', startOfDay.toIso8601String())
        .lt('date', endOfDay.toIso8601String());

    return (response as List).map((json) => Task.fromJson(json)).toList();
  }
}
