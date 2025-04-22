import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:task_app/services/task_service.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/app_colors.dart';
import 'package:task_app/screens/dashboard/task_tile.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await TaskService().getTasksByDate(_selectedDate);
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    _loadTasks();
  }

  Future<void> _toggleTaskCompletion(Task task, bool? isCompleted) async {
    final updatedTask = task.copyWith(isCompleted: isCompleted);
    await _taskService.updateTask(updatedTask);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EasyDateTimeLinePicker(
              focusedDate: _selectedDate,
              firstDate: DateTime(2010, 3, 18),
              lastDate: DateTime(2030, 3, 18),
              onDateChange: (date) {
                setState(() => _selectedDate = date);
                _loadTasks();
              },
              headerOptions: HeaderOptions(headerType: HeaderType.picker),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task",
                  style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child:
                      _tasks.isEmpty
                          ? const Center(
                            child: Text(
                              "No tasks for this day.",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                final task = _tasks[index];
                                return TaskTile(
                                  task: task,
                                  onDelete: () {
                                    _deleteTask(task.id);
                                  },
                                  onEdit: () {
                                    // Optional: handle edit
                                  },
                                  onChecked: (value) {
                                    _toggleTaskCompletion(task, value);
                                  },
                                );
                              },
                            ),
                          ),
                ),
          ],
        ),
      ),
    );
  }
}
