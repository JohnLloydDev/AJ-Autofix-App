import 'package:aj_autofix/bloc/auth/auth_event.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/models/user_model.dart';
import 'package:aj_autofix/repositories/auth_repository_impl.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl;
  bool isVerified = false;

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
        if (e.toString().contains('Invalid email or password')) {
          emit(const AuthFailed('Invalid email or password.'));
        } else {
          emit(const AuthFailed('Login failed. Please try again.'));
        }
      }
    });

    on<LogoutRequest>((event, emit) async {
      try {
        await _authRepositoryImpl.userLogout();
        emit(const LogoutSucceed('Logout Success'));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
    on<VerifyEmail>((event, emit) async {
      emit(AuthIsProcessing());
      try {
        final isSuccess =
            await _authRepositoryImpl.verifyUserEmail(event.token);
        if (isSuccess) {
          isVerified = true;
          emit(EmailVerificationSuccess());
        } else {
          emit(const EmailVerificationFailed(
              'Verification failed, please try again.'));
        }
      } catch (e) {
        emit(EmailVerificationFailed('Error occurred: ${e.toString()}'));
      }
    });

on<RequestOtp>((event, emit) async {
  emit(AuthIsProcessing());
  try {
    await _authRepositoryImpl.requestOtp(event.email);
    emit(OtpRequestSuccess("OTP sent successfully to ${event.email}"));
  } catch (e) {
    if (e.toString().contains('The provided email address was not found')) {
      emit(const OtpRequestFailed(
          'The provided email address was not found. Please check and try again.'));
    } else {
      emit(OtpRequestFailed(e.toString()));  
    }
  }
});


    on<ResetPassword>((event, emit) async {
      emit(AuthIsProcessing());
      try {
        await _authRepositoryImpl.resetPasswordWithOtp(
          event.email,
          event.otp,
          event.newPassword,
        );
        emit(const PasswordResetSuccess('Password reset successful!'));
      } catch (e) {
        if (e.toString().contains('Invalid OTP')) {
          emit(const PasswordResetFailed('Invalid OTP. Please try again.'));
        } else {
          emit(
              PasswordResetFailed('Failed to reset password: ${e.toString()}'));
        }
      }
    });
  }
}
