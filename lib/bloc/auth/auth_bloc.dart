import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_app/screens/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authService.signUp(
          event.email,
          event.password,
          event.name,
        );

        if (response.user != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Sign up failed. Please try again."));
        }
      } catch (e) {
        emit(AuthFailure('Sign up failed. Please try again.'));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _authService.signIn(event.email, event.password);

        if (response.user != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure("Invalid email or password. Please try again"));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again."));
      }
    });
  }
}
