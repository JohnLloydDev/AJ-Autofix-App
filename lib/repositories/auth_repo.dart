import 'package:aj_autofix/models/user_model.dart';

abstract class AuthRepo {
  Future<User> userRegister(User user);
  Future<User> userLogin(User user);
}
