part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

class LoadTasks extends DashboardEvent {}

class AddTask extends DashboardEvent {
  final String taskName;
  final DateTime selectedDate;

  AddTask({required this.taskName, required this.selectedDate});
}

class DeleteTask extends DashboardEvent {
  final String taskId;

  DeleteTask({required this.taskId});
}

class UpdateTask extends DashboardEvent {
  final Task updatedTask;

  UpdateTask({required this.updatedTask});
}

class LogoutUser extends DashboardEvent {}
