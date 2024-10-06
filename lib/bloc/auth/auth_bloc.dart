import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository_impl.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl;

  AuthBloc(this._authRepositoryImpl) : super(AuthInitial()) {
    on<UserRegistration>((event, emit) async {
      try {
        await _authRepositoryImpl.userRegistration(
            event.user, event.profilePicture);
        emit(const AuthSucceed('Registration Success'));
      } catch (e) {
        if (e.toString().contains('Email already exists')) {
          emit(const AuthFailed('This email is already registered.'));
        } else if (e.toString().contains('Username already exists')) {
          emit(const AuthFailed('This username is already registered.'));
        } else {
          emit(const AuthFailed('Registration failed. Please try again.'));
        }
      }
    });

    on<UserLogin>((event, emit) async {
      try {
        final User user = await _authRepositoryImpl.userLogin(event.user);

        emit(AuthSuccessWithRole(user.role, user));
      } catch (e) {
        if (e.toString().contains('Invalid credentials')) {
          emit(const AuthFailed('Invalid username or password.'));
        } else {
          emit(const AuthFailed('Login failed. Please try again.'));
        }
      }
    });

    on<LogoutRequest>((event, emit) async {
      try {
        await _authRepositoryImpl.userLogout();
        emit(const AuthSucceed('Logout Success'));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthReset>((event, emit) => emit(AuthInitial()));
  }
}
