part of 'dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Task> tasks;

  DashboardLoaded({required this.tasks});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

class LoggedOut extends DashboardState {}
