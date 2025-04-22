import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/dashboard/dashboard_bloc.dart';
import 'package:task_app/screens/auth/login_screen.dart';
import 'package:task_app/screens/dashboard/add_task.dart';
import 'package:task_app/screens/dashboard/task_tile.dart';
import 'package:task_app/screens/dashboard/update_task.dart';
import 'package:task_app/utils/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadTasks()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.purple,
          actions: [
            IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: Icon(Icons.logout, color: AppColors.white),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DashboardError) {
                return Center(child: Text(state.message));
              }

              if (state is DashboardLoaded) {
                final tasks = state.tasks;

                final today = DateTime.now();
                final todayDate = DateTime(today.year, today.month, today.day);
                final todayTasks =
                    tasks.where((task) {
                      final taskDate = DateTime(
                        task.date.year,
                        task.date.month,
                        task.date.day,
                      );
                      return taskDate == todayDate;
                    }).toList();

                final pendingCount =
                    tasks.where((task) => !task.isCompleted).length;
                final completedCount =
                    tasks.where((task) => task.isCompleted).length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      _summaryCard("Pending Tasks", pendingCount),
                      const SizedBox(height: 20),
                      _summaryCard("Completed", completedCount),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Today Tasks",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.purple,
                          ),
                        ),
                      ),

                      if (todayTasks.isEmpty)
                        const Center(
                          child: Text(
                            "No tasks for today.",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 20,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todayTasks.length,
                          itemBuilder: (context, index) {
                            final task = todayTasks[index];
                            return TaskTile(
                              task: task,

                              onDelete: () {
                                context.read<DashboardBloc>().add(
                                  DeleteTask(taskId: task.id),
                                );
                              },
                              onEdit: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => UpdateTaskDialog(
                                        task: task,
                                        onTaskUpdated: (
                                          updatedName,
                                          updatedDate,
                                        ) {
                                          final updatedTask = task.copyWith(
                                            taskName: updatedName,
                                            date: updatedDate,
                                          );
                                          context.read<DashboardBloc>().add(
                                            UpdateTask(
                                              updatedTask: updatedTask,
                                            ),
                                          );
                                        },
                                      ),
                                );
                              },
                              onChecked: (value) {
                                context.read<DashboardBloc>().add(
                                  UpdateTask(
                                    updatedTask: task.copyWith(
                                      isCompleted: value ?? false,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.purple,
          elevation: 3,
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AddTaskDialog(
                    onTaskAdded: (taskName, selectedDate) {
                      context.read<DashboardBloc>().add(
                        AddTask(taskName: taskName, selectedDate: selectedDate),
                      );
                    },
                  ),
            );
          },
          child: const Icon(Icons.add, size: 40, color: AppColors.lightPurple),
        ),
      ),
    );
  }

  Widget _summaryCard(String title, int count) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        elevation: 4,
        color: AppColors.lightPurple,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$count",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                context.read<DashboardBloc>().add(LogoutUser());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
