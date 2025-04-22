import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String taskName, DateTime date) onTaskAdded;
  const AddTaskDialog({super.key, required this.onTaskAdded});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _taskNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskNameController,
            decoration: const InputDecoration(hintText: 'Task description'),
          ),

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

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_taskNameController.text.trim().isNotEmpty) {
              widget.onTaskAdded(
                _taskNameController.text.trim(),
                _selectedDate,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
