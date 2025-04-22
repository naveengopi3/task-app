import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/services/task_service.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
    on<LogoutUser>(_onLogoutUser);
  }

  final TaskService _taskService = TaskService();
  final String? _userId = Supabase.instance.client.auth.currentUser?.id;

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<DashboardState> emit,
  ) async {
    if (_userId == null) {
      emit(DashboardError(message: "Something wrong please try again"));
      return;
    }

    emit(DashboardLoading());
    try {
      final stream = _taskService.taskStream(_userId);
      await emit.forEach<List<Task>>(
        stream,
        onData: (tasks) {
          return DashboardLoaded(tasks: tasks);
        },
      );
    } catch (e) {
      emit(DashboardError(message: "Failed to load tasks."));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<DashboardState> emit) async {
    if (_userId == null) return;

    final newTask = Task(
      id: const Uuid().v4(),
      taskName: event.taskName,
      date: event.selectedDate,
      isCompleted: false,
      userId: _userId,
    );
    await _taskService.createTask(newTask);
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<DashboardState> emit,
  ) async {
    await _taskService.deleteTask(event.taskId);
    final stream = _taskService.taskStream(_userId!);
    await emit.forEach<List<Task>>(
      stream,
      onData: (tasks) {
        return DashboardLoaded(tasks: tasks);
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<DashboardState> emit,
  ) async {
    await _taskService.updateTask(event.updatedTask);
  }

  Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      await Supabase.instance.client.auth.signOut();
      emit(LoggedOut());
    } catch (e) {
      emit(DashboardError(message: "Failed to log out."));
    }
  }
}
