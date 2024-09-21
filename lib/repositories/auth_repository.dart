import 'dart:io';

import 'package:aj_autofix/models/user_model.dart';

abstract class AuthRepository {
  Future<User> userRegistration(User user, File? profilePicture);
  Future<User> userLogin(User user);
}
