import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/bloc/user/user_event.dart';
import 'package:aj_autofix/bloc/user/user_state.dart';
import 'package:aj_autofix/repositories/admin_repository.dart';
import 'package:bloc/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AdminRepository adminRepository;

  UserBloc(this.adminRepository) : super(UserDataLoading()) {
    on<GetUsers>((event, emit) async {
      try {
        emit(UserDataLoading());
        final userdata = await adminRepository.getUser();
        emit(UserDataLoaded(userdata));
      } catch (e) {
        emit(UserDataError(e.toString()));
      }
    });

    on<GetUsersById>(
      (event, emit) async {
        try {
          emit(UserDataLoading());
          final user = await adminRepository.getUsers(event.id);
          emit(UserDataLoadedById(user));
        } catch (e) {
          emit(UserDataError(e.toString()));
        }
      },
    );

    on<DeleteUser>((event, emit) async {
      try {
        await adminRepository.deleteUser(event.id);
        add(GetUsers());
      } catch (e) {
        emit(UserDataError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      try {
        await adminRepository.updateUser(event.id, event.user);
        add(GetUsers());
        emit(const UserDataSuccess('User Updated Successfully'));
      } catch (e) {
        emit(UserDataError(e.toString()));
      }
    });

    on<AdminReset>(
      (event, emit) => AuthInitial(),
    );
  }
}
