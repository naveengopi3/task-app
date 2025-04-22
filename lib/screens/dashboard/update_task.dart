import 'package:flutter/material.dart';
import 'package:task_app/models/task_model.dart';

class UpdateTaskDialog extends StatefulWidget {
  final Task task;
  final Function(String taskName, DateTime selectedDate) onTaskUpdated;

  const UpdateTaskDialog({
    super.key,
    required this.task,
    required this.onTaskUpdated,
  });

  @override
  State<UpdateTaskDialog> createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<UpdateTaskDialog> {
  late TextEditingController _taskNameController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.task.taskName);
    _selectedDate = widget.task.date;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskNameController,
            decoration: const InputDecoration(hintText: "Task description"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(
              text: _selectedDate.toLocal().toString().split(' ')[0],
            ),
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Select due date',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            final trimmedName = _taskNameController.text.trim();
            if (trimmedName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Task name cannot be empty")),
              );
              return;
            }

            widget.onTaskUpdated(trimmedName, _selectedDate);
            Navigator.of(context).pop();
          },
          child: const Text("Update"),
        ),
      ],
    );
  }
}
