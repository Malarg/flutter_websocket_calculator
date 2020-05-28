import 'dart:math';

import 'package:calculator_server/calculator_server.dart';

class UserRepository {
  factory UserRepository() {
    return _singleton;
  }

  UserRepository._internal();

  static final _singleton = UserRepository._internal();

  static final _users = <User>[];

  List<User> get() => _users;

  User insert(User user) {
    if (user.id < 0) {
      if (_users.isNotEmpty) {
        user.id = _generateNewId();
      } else {
        user.id = 1;
      }
    }
    _users.add(user);
    return user;
  }

  int _generateNewId() => _users.map((e) => e.id).reduce(max) + 1;
}
