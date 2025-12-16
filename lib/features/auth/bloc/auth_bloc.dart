import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 2));

    if (event.username == 'admin' && event.password == '1234') {
      emit(AuthSuccess());
    } else {
      emit(const AuthFailure('Invalid username or password'));
    }
  }
}