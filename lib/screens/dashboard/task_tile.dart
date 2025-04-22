import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/app_colors.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool?> onChecked;
  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(task.date);
    return Slidable(
      key: Key(task.id),
      endActionPane: ActionPane(
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Card(
          color: AppColors.white,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.purple,
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.purple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
                    Checkbox(value: task.isCompleted, onChanged: onChecked),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
