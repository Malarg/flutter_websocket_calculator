import 'package:calculator_server/calculator_server.dart';

class UserController extends ResourceController {
  UserController();

  final _repository = UserRepository();

  @Operation.get()
  Future<Response> getUsers() async {
    return Response.ok(_repository.get().map((e) => e.toJson()));
  }
}
