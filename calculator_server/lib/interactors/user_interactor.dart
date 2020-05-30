import 'package:calculator_server/calculator_server.dart';

class UserInteractor {
  UserInteractor();

  final _repository = UserRepository();

  List<User> getUsers() => _repository.get();

  User addUser(User user) => _repository.insert(user);
}
