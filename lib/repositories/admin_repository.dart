import 'package:aj_autofix/models/user_model.dart';

abstract class AdminRepository {
  Future <List<User>> getUser();
  Future<User> getUsers(String id);
  Future<void> updateUser(String id, User user);
  Future<void> deleteUser(String id);
}
